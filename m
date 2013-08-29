Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab3H2RcO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Aug 2013 13:32:14 -0400
Received: from mail-ob0-f175.google.com ([209.85.214.175]:61231 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755525Ab3H2RcL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Aug 2013 13:32:11 -0400
MIME-Version: 1.0
In-Reply-To: <20130829160830.GB25021@roeck-us.net>
References: <1374486633-9737-1-git-send-email-simon.guinot@sequanux.org>
	<CACRpkda2bH_TkFR6c0cXvjye4SmFWN5xuzQSO=NqBq8mNDgV0g@mail.gmail.com>
	<20130801134632.GY9916@kw.sim.vm.gnt>
	<CACRpkdZcEPM-u19pc+v_cRqUSfJBFZ49rJYiewQ1sWWSU5YxEg@mail.gmail.com>
	<20130829125754.GA8813@srcf.ucam.org>
	<521F4F95.5080103@roeck-us.net>
	<20130829153738.GA16306@srcf.ucam.org>
	<20130829160830.GB25021@roeck-us.net>
Date: Thu, 29 Aug 2013 19:32:10 +0200
Message-ID: <CACRpkdZN8tV0pazo9jbc+nMSt0ye4qbYJyfBGMPcNoekfeqP9g@mail.gmail.com>
Subject: Re: [PATCH v3] gpio: add GPIO support for F71882FG and F71889F
From: Linus Walleij <linus.walleij@linaro.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Simon Guinot <simon.guinot@sequanux.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 29, 2013 at 6:08 PM, Guenter Roeck <linux@roeck-us.net> wrote:
> On Thu, Aug 29, 2013 at 04:37:38PM +0100, Matthew Garrett wrote:

>> The majority of board vendors clearly don't expect the OS to drive the
>> hwmon chips - they're there for the benefit of ACPI and SMM code. That
>> doesn't mean that there's no benefit in having drivers for them, just
>> that the board vendors don't care about that use case and so won't do
>> anything to make it easier.
>>
> Actually, not entirely true. Some vendors even provide software running on
> Windows to access those chips (including access to fans controlled through
> GPIO pins) and to provide information to the user. It might be more accurate
> to say that some board vendors don't care about Linux (or about providing
> access through ACPI, for that matter).
>
> Question here is what the Linux kernel community's policy is going to be
> to handle such cases. Pragmatic or dogmatic ?

The GPIO maintainer is going to be pragmatic, because it's cool to
be able to control HWMON things on one's workstation.

The kernel is a funnier place with these drivers, so I'm applying the
patch.

Yours,
Linus Walleij
