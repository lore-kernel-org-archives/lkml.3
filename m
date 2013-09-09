Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab3IILTa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Sep 2013 07:19:30 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:60527 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab3IILT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Sep 2013 07:19:28 -0400
Message-ID: <522DAE69.4050608@ahsoftware.de>
Date: Mon, 09 Sep 2013 13:18:01 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: Guenter Roeck <linux@roeck-us.net>,
        Daniel Santos <daniel.santos@pobox.com>,
        Daniel Santos <danielfsantos@att.net>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        linux-spi <linux-spi@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: "Virtual" Interrupts -- Need help please
References: <522BC27A.5080303@att.net> <522BCA33.6000701@roeck-us.net> <522D0D37.3050500@att.net> <522D17EC.3050908@roeck-us.net> <20130909110257.GU29403@sirena.org.uk>
In-Reply-To: <20130909110257.GU29403@sirena.org.uk>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 09.09.2013 13:02, schrieb Mark Brown:
> On Sun, Sep 08, 2013 at 05:35:56PM -0700, Guenter Roeck wrote:
>
> Please fix your mailer to word wrap within paragraphs, not doing this
> makes your mail very hard to read.  It looks like your mailer has also
> reflowed Daniel's mail.

That's just wrong. Mail readers should wrap lines, not senders. And 
readers can do this since some decades.

The reason is obvious: No sender knows the line width the receiver can 
display. So, for example, if the sender hard breaks lines every 80 
chars, a reader with a device which just displays 60 characters at max. 
will see every second line with at most 20 characters. I assume you can 
guess how such does look like. Furthermore there are still a lot of 
people which do like to read mails with line length as long their 
display is possible to show, and hard breaking lines on the receiver 
side does make such impossible.

So the correct behaviour is to not hard break lines on the sender side 
and leave that to the reader on the receiving side, as only the 
receiving side knows the line width.

Alexander Holler

