Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753604Ab3IIOWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 10:22:30 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60156 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab3IIOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 10:22:29 -0400
Message-ID: <522DD977.2040504@ahsoftware.de>
Date: Mon, 09 Sep 2013 16:21:43 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        Daniel Santos <daniel.santos@pobox.com>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: "Virtual" Interrupts -- Need help please
References: <522BC27A.5080303@att.net> <522BCA33.6000701@roeck-us.net> <522D0D37.3050500@att.net> <522D17EC.3050908@roeck-us.net> <20130909110257.GU29403@sirena.org.uk> <522DAE69.4050608@ahsoftware.de> <20130909134558.GY29403@sirena.org.uk>
In-Reply-To: <20130909134558.GY29403@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.09.2013 15:45, schrieb Mark Brown:
> On Mon, Sep 09, 2013 at 01:18:01PM +0200, Alexander Holler wrote:
>> Am 09.09.2013 13:02, schrieb Mark Brown:
> 
>>> makes your mail very hard to read.  It looks like your mailer has also
>>> reflowed Daniel's mail.
> 
>> That's just wrong. Mail readers should wrap lines, not senders. And
>> readers can do this since some decades.
> 
> There's a specific way for senders to request that if it's desired, set
> format=flowed in the MIME type to tell the recipient that the formatting
> isn't important.
> 
>> The reason is obvious: No sender knows the line width the receiver
>> can display. So, for example, if the sender hard breaks lines every
>> 80 chars, a reader with a device which just displays 60 characters
>> at max. will see every second line with at most 20 characters. I
>> assume you can guess how such does look like. Furthermore there are
>> still a lot of people which do like to read mails with line length
>> as long their display is possible to show, and hard breaking lines
>> on the receiver side does make such impossible.
> 
>> So the correct behaviour is to not hard break lines on the sender
>> side and leave that to the reader on the receiving side, as only the
>> receiving side knows the line width.
> 
> This doesn't work well with lots of content (like patches) commonly
> handled in technical contexts - the line breaks actually mean something
> and it's hard fo the mail client to figure out what is going on unless
> someone tells it.

I wonder what all the hard line breaks you added to your mail do mean?

Hard line breaks in paragraphs, as you've requested, doesn't mean
anything. They just make eamils extremly ugly, e.g. your one is
displayed here with a whole lot of unused white space because I'm not
using a CGA screen. And people who do read your mail on a phone with
less than 80 or 75 chars will see it as even more ugly.

And imho it just works if hard line breaks are used where they belong
too, the code or to end paragraphs or otherwise where they have a
meaning, but not just always after 75 or 80 chars.

Regards,

Alexander Holler
