Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755568AbaIWM4x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:56:53 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:59723 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551AbaIWM4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:56:51 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Boris BREZILLON <boris.brezillon@free-electrons.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Johan Hovold <jhovold@gmail.com>, Mark Rutland <mark.rutland@arm.com>,
        devicetree@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Kumar Gala <galak@codeaurora.org>
Subject: Re: [PATCH v8 09/10] rtc: at91sam9: add DT bindings documentation
Date: Tue, 23 Sep 2014 14:56:37 +0200
Message-ID: <3728270.N2tTcyeJmL@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1411471444-2764-10-git-send-email-boris.brezillon@free-electrons.com>
References: <1411471444-2764-1-git-send-email-boris.brezillon@free-electrons.com> <1411471444-2764-10-git-send-email-boris.brezillon@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:G6e8vDpepOP6miZbpXIU4nk87mbgvhXZiCneTUmkFrg
 pZpyt9APoFHySpoeUmrrgrWCYXO0t80rWW7e9QuYUHTpVJ88eS
 JurYCZU6aXgt1J8J8gqvjs5k9xY71SnqhoyJO+YVBV6RZEp6/H
 lpBQI6f63Q/VASVCkNtD2ewVJkXsEmCfMb44DvX7nGh79whXS+
 Tk+wNgoYYTre5m/Q1WTDTmdzKUxu9K7gaZkor2tQuZLAdkIHLZ
 M6lFbGe2o8qju/iw0j+Qu+QwwEe2vW5bhhFV4n4zKY3zlKdEyo
 zpy5Dva6ILHhkOQ73ADlA0Ch/gHg+URPwFy24bDH1n8nmcwmp1
 NmFzk9CafstZRfR/b+mk=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 September 2014 13:24:03 Boris BREZILLON wrote:
> Add RTT bindings documentation.

Two minor comments here:

> +Atmel AT91SAM9260 Real Time Timer
> +
> +Required properties:
> +- compatible: should be: "atmel,at91sam9260-rtt"
> +- reg: should encode the memory region of the RTT controller
> +- interrupts: rtt alarm/event interrupt
> +- clocks: should contain one clock pointing to the slow clk

This should document what the clock is used for, not where it's
connected.

> +
> +rtt@fffffe00 {
> +       compatible = "atmel,at91sam9260-rtt";
> +       reg = <0xfffffd20 0x10>;
> +       interrupts = <1 4 7>;
> +       clocks = <&clk32k>;
> +       atmel,rtt-rtc-time-reg = <&gpbr 0x0>;
> +};
> 

The register address fffffd20 does not match the name fffffe00

	Arnd

