Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754324Ab3H2QIf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 12:08:35 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:56016 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab3H2QId (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 12:08:33 -0400
Date: Thu, 29 Aug 2013 09:08:30 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Simon Guinot <simon.guinot@sequanux.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
Message-ID: <20130829160830.GB25021@roeck-us.net>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
 <CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
 <20130801134632.GY9916@kw.sim.vm.gnt>
 <CACRpkdZcEPM-u19pc+v_cRqUSfJBFZ49rJYiewQ1sWWSU5YxEg@mail.gmail.com>
 <20130829125754.GA8813@srcf.ucam.org>
 <521F4F95.5080103@roeck-us.net>
 <20130829153738.GA16306@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130829153738.GA16306@srcf.ucam.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 04:37:38PM +0100, Matthew Garrett wrote:
> On Thu, Aug 29, 2013 at 06:41:41AM -0700, Guenter Roeck wrote:
> > On 08/29/2013 05:57 AM, Matthew Garrett wrote:
> > >If a vendor doesn't provide any way to autoprobe a device, there's no
> > >way to autoprobe a device. That usually means that you're not expected
> > >to use that device.
> > >
> > 
> > Pretty radical. Following your advice, should we remove all watchdog
> > and hwmon drivers for all SuperIO chips out there, plus any existing
> > gpio drivers (drivers/char/pc8736x_gpio.c might be a candidate) ?
> 
> The majority of board vendors clearly don't expect the OS to drive the 
> hwmon chips - they're there for the benefit of ACPI and SMM code. That 
> doesn't mean that there's no benefit in having drivers for them, just 
> that the board vendors don't care about that use case and so won't do 
> anything to make it easier.
> 
Actually, not entirely true. Some vendors even provide software running on
Windows to access those chips (including access to fans controlled through
GPIO pins) and to provide information to the user. It might be more accurate
to say that some board vendors don't care about Linux (or about providing
access through ACPI, for that matter).

Question here is what the Linux kernel community's policy is going to be
to handle such cases. Pragmatic or dogmatic ?

Guenter
