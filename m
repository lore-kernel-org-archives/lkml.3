Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754087AbaFPHQB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2014 03:16:01 -0400
Received: from donald.hachti.de ([188.40.85.216]:59589 "EHLO donald.hachti.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753924AbaFPHP7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2014 03:15:59 -0400
Message-ID: <539E99AB.9030907@hachti.de>
Date: Mon, 16 Jun 2014 09:15:55 +0200
From: Philipp Hachtmann <hachti@hachti.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Johan Hovold <johan@kernel.org>, Sascha Silbe <x-linux@infra-silbe.de>
CC: Johan Hovold <jhovold@gmail.com>, Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] USB: ftdi_sio: add GPIO support
References: <1402320115-13171-1-git-send-email-x-linux@infra-silbe.de> <20140610105631.GA10256@localhost>
In-Reply-To: <20140610105631.GA10256@localhost>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

> Would this patch interfere with adding support for using the CBUS pins
> as GPIOs while operating in normal UART mode?

Most interesting question!

>> Care was taken to prevent using GPIOs if the serial device is in use
>> and vice versa.

What about CBUS GPIO support?

> Ok, so we're not extending the serial driver with support for
> controlling some unused pins (e.g. CBUS) but rather implementing support
> for a mutually exclusive mode.
For bitbang mode (on the data lines) - yes. But for bitbang on CBUS - no.


I have sent a proposal a few weeks ago but Greg did not like special 
sysfs stuff :-P
He asked me to use the GPIO subsystem for the CBUS pins. I am out of 
time until july. But I still want and need CBUS support in parallel with 
serial/FIFO operation.


Regards

Philipp
