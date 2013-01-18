Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755623Ab3ARNS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 08:18:28 -0500
Received: from antcom.de ([188.40.178.216]:50037 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751511Ab3ARNS1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 08:18:27 -0500
Message-ID: <50F94B9F.7020908@antcom.de>
Date: Fri, 18 Jan 2013 14:18:23 +0100
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.11) Gecko/20121123 Icedove/10.0.11
MIME-Version: 1.0
To: Stijn Devriendt <highguy@gmail.com>
CC: gregkh@linuxfoundation.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, w.sang@pengutronix.de,
        jbe@pengutronix.de, plagnioj@jcrosoft.com,
        broonie@opensource.wolfsonmicro.com, daniel-gl@gmx.net,
        rmallon@gmail.com, sr@denx.de, wg@grandegger.com,
        tru@work-microwave.de, mark.rutland@arm.com
Subject: Re: [PATCH RESEND 1/6 v13] gpio: Add a block GPIO API to gpiolib
References: <1358250716-21986-1-git-send-email-stigge@antcom.de> <1358250716-21986-2-git-send-email-stigge@antcom.de> <CAOY=C6EE1yxjxUR6XvxW5tbY8FPBeO2Nqo6wMeD5R3zAVYD+Ag@mail.gmail.com>
In-Reply-To: <CAOY=C6EE1yxjxUR6XvxW5tbY8FPBeO2Nqo6wMeD5R3zAVYD+Ag@mail.gmail.com>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stijn,

On 01/18/2013 01:13 PM, Stijn Devriendt wrote:
> Hi Roland,
> 
> This mail has been long overdue due to issues with some internal
> permission-tool.
> Just to be clear, this is not a competing implementation, it's what we
> currently use as-is. I'm just posting this as a reference to see if
> perhaps more concepts could be reused. It's based on a 2.6.32 kernel.
> 
> It includes:
> - labels in sysfs (to provide useful names to userspace)
> - gpio group support
> - exporting individual/groups of gpios dictated by platform-data or device-tree
> - open-drain support (different from mainline)
> - examplary support for multi-gpio to pcf8575 driver
> - gpio_direction_output_keep() function that prevents toggling when
> changing direction
> 
> Provided-as-is-by: Stijn Devriendt <sdevrien@cisco.com>

Thanks for posting.

Except for open-drain support, everything in the above list is supported
in the last posted version of block GPIO.

So please tell if there are certain details you would like to discuss
about or need an alternative implementation.

Thanks in advance,

Roland
