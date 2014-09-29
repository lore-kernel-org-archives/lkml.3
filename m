Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755072AbaI2Nka (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 09:40:30 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:49377 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754539AbaI2Nk0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 09:40:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: zhang.lyra@gmail.com
Cc: catalin.marinas@arm.com, gregkh@linuxfoundation.org,
        ijc+devicetree@hellion.org.uk, jslaby@suse.cz, galak@codeaurora.org,
        broonie@linaro.org, mark.rutland@arm.com, m-karicheri2@ti.com,
        pawel.moll@arm.com, artagnon@gmail.com, rrichter@cavium.com,
        robh+dt@kernel.org, will.deacon@arm.com, orsonzhai@gmail.com,
        geng.ren@spreadtrum.com, zhizhou.zhang@spreadtrum.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        "chunyan.zhang" <chunyan.zhang@spreadtrum.com>
Subject: Re: [PATCH 1/6] Documentation: DT: Add bindings for Spreadtrum serial
Date: Mon, 29 Sep 2014 15:39:23 +0200
Message-ID: <5399512.qxHSYW7FgQ@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411992293-7729-2-git-send-email-zhang.lyra@gmail.com>
References: <1411992293-7729-1-git-send-email-zhang.lyra@gmail.com> <1411992293-7729-2-git-send-email-zhang.lyra@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:7FMijkwUQ7M3CMqzmxR6X3U4zVOoV40op14iDUUYMHC
 vXf1N8WaZOJJweD7d9jNXn8Qcqu4Z5SMsExeRF3x4MiVLnGKdB
 P+fsaoO+BtLbwZ9LCL9Oihc10Ad4G1tK9rFkebVV42w8DLGYok
 l6abs/dF1IU/g1xkQGFN1nwiFXQH8GE0RChAGEuA1Ue3BRegQl
 lGG7RwKNewnhp6SzClFbccgZmXmiC0Kky1n6lbn4icTZ9viInn
 7GVtanp7W046lUGdE3cSutXAKdUjxVLZyStLiZaGqeCq23A6IW
 O12IRMRI5fcZeESR0xJCd9/gsvveVFxuPRP4eAxvgM2MO0mhTK
 BFJfv5YkJpngRDdwwaAU=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 29 September 2014 20:04:48 zhang.lyra@gmail.com wrote:
> diff --git a/Documentation/devicetree/bindings/serial/of-serial.txt b/Documentation/devicetree/bindings/serial/of-serial.txt
> index 7705477..a0bb1d1 100644
> --- a/Documentation/devicetree/bindings/serial/of-serial.txt
> +++ b/Documentation/devicetree/bindings/serial/of-serial.txt
> @@ -14,6 +14,7 @@ Required properties:
>         - "altr,16550-FIFO32"
>         - "altr,16550-FIFO64"
>         - "altr,16550-FIFO128"
> +       - "sprd,serial"
>         - "serial" if the port type is unknown.
>  - reg : offset and length of the register set for the device.
>  - interrupts : should contain uart interrupt.
> 

This file is really only for 8250 compatible UART implementations, please
add a new file with a proper binding for your serial port. It would be
nice if you could rename this file to 8250.txt to avoid confusing the
next person.

Please also add the "sprd" prefix to
Documentation/devicetree/bindings/vendor-prefixes.txt

	Arnd
