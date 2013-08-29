Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754330Ab3H2QZ6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:25:58 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:52869 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752519Ab3H2QZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:25:56 -0400
Date: Thu, 29 Aug 2013 17:25:51 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Simon Guinot <simon.guinot@sequanux.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
Message-ID: <20130829162551.GA17411@srcf.ucam.org>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
 <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
 <20130801134632.GY9916@kw.sim.vm.gnt>
 <CACRpkdZcEPM-u19pc+v_cRqUSfJBFZ49rJYiewQ1sWWSU5YxEg@mail.gmail.com>
 <20130829125754.GA8813@srcf.ucam.org>
 <521F4F95.5080103@roeck-us.net>
 <20130829153738.GA16306@srcf.ucam.org>
 <20130829160830.GB25021@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829160830.GB25021@roeck-us.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 09:08:30AM -0700, Guenter Roeck wrote:
> On Thu, Aug 29, 2013 at 04:37:38PM +0100, Matthew Garrett wrote:
> > On Thu, Aug 29, 2013 at 06:41:41AM -0700, Guenter Roeck wrote:
> > The majority of board vendors clearly don't expect the OS to drive the 
> > hwmon chips - they're there for the benefit of ACPI and SMM code. That 
> > doesn't mean that there's no benefit in having drivers for them, just 
> > that the board vendors don't care about that use case and so won't do 
> > anything to make it easier.
> > 
> Actually, not entirely true. Some vendors even provide software running on
> Windows to access those chips (including access to fans controlled through
> GPIO pins) and to provide information to the user. It might be more accurate
> to say that some board vendors don't care about Linux (or about providing
> access through ACPI, for that matter).

Eh. If they're really providing code that just assumes that hardware is 
present and bangs on it, what choice do we have? You've checked that the 
machines in question don't have a magic ACPI device that provides 
resource information?

> Question here is what the Linux kernel community's policy is going to be
> to handle such cases. Pragmatic or dogmatic ?

I don't see any benefit in changing the status quo. Sometimes hardware 
is just shit. The majority of x86 vendors certainly don't care about 
anything we do, so it's not like we're in a position to force them to 
change.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
