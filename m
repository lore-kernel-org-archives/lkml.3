Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab3IILpl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:45:41 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63046 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752739Ab3IILpj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:45:39 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <522DB4E1.7080507@roeck-us.net>
Date: Mon, 09 Sep 2013 04:45:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: Mark Brown <broonie@kernel.org>, Daniel Santos <daniel.santos@pobox.com>,
        Daniel Santos <danielfsantos@att.net>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: "Virtual" Interrupts -- Need help please
References: <522BC27A.5080303@att.net> <522BCA33.6000701@roeck-us.net> <522D0D37.3050500@att.net> <522D17EC.3050908@roeck-us.net> <20130909110257.GU29403@sirena.org.uk> <522DAE69.4050608@ahsoftware.de>
In-Reply-To: <522DAE69.4050608@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2013 04:18 AM, Alexander Holler wrote:
> Am 09.09.2013 13:02, schrieb Mark Brown:
>> On Sun, Sep 08, 2013 at 05:35:56PM -0700, Guenter Roeck wrote:
>>
>> Please fix your mailer to word wrap within paragraphs, not doing this
>> makes your mail very hard to read.  It looks like your mailer has also
>> reflowed Daniel's mail.
>
> That's just wrong. Mail readers should wrap lines, not senders. And readers can do this since some decades.
>
> The reason is obvious: No sender knows the line width the receiver can display. So, for example, if the sender hard breaks lines every 80 chars, a reader with a device which just displays 60 characters at max. will see every second line with at most 20 characters. I assume you can guess how such does look like. Furthermore there are still a lot of people which do like to read mails with line length as long their display is possible to show, and hard breaking lines on the receiver side does make such impossible.
>
> So the correct behaviour is to not hard break lines on the sender side and leave that to the reader on the receiving side, as only the receiving side knows the line width.
>

I am using thunderbird and/or mutt. I don't think they reflow anything,
or at least the logged mail doesn't seem to have been reflowed (nor
does the text above).

As for what I write myself, I prefer to wrap manually, meaning automatic
insertion of newlines is turned off. Guess I can not do it right for everyone.

Guenter

