Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760083AbaGYJC2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 05:02:28 -0400
Received: from top.free-electrons.com ([176.31.233.9]:54139 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751221AbaGYJCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 05:02:22 -0400
Date: Fri, 25 Jul 2014 11:02:06 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: =?utf-8?B?SmnFmcOt?= Prchal <jiri.prchal@aksignal.cz>
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        devicetree@vger.kernel.org, nicolas.ferre@atmel.com,
        linux-arm-kernel@lists.infradead.org, Bo Shen <voice.shen@atmel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: at91: at91sam9x5: sets NPCS0 (PA14) back to GPIO
Message-ID: <20140725090206.GG9532@piout.net>
References: <1405074175-22444-1-git-send-email-voice.shen@atmel.com>
 <53D10C50.50305@aksignal.cz>
 <20140724162645.4e19c26c@bbrezillon>
 <53D12103.3020103@aksignal.cz>
 <20140724175848.44f5da10@bbrezillon>
 <53D1F5D0.1080006@aksignal.cz>
 <20140725083053.GD9532@piout.net>
 <53D2174B.4020403@aksignal.cz>
 <20140725085436.GF9532@piout.net>
 <53D21C57.3010805@aksignal.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53D21C57.3010805@aksignal.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25/07/2014 at 10:59:03 +0200, Jiří Prchal wrote :
> >>Of course, it's the way, but in all other drivers, for example LEDS,
> >>it's not needed. And in other way, if I will not use PA14 at all,
> >>the pin will goes down every spi transfer.
> >
> >You must not assumed that the pins are muxed to their default state
> >which is gpio and you should set the pinctrl accordingly for each
> >device.
> >
> >If you don't use PA14 at all, then you don't really care about its
> >state...
> Yes and no, what about on board is populated some chip on PA14, but
> for some reason at this time I don't need it and not defined in DT?
> >

If this is really an issue for that chip, I would think that you will
change the bootloader to not mux PA14 to periph A and stop it from
trying to read it like an spi flash ?

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
