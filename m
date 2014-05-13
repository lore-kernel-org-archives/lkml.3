Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964877AbaEMOrW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 10:47:22 -0400
Received: from top.free-electrons.com ([176.31.233.9]:39518 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S933780AbaEMOrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 10:47:18 -0400
Date: Tue, 13 May 2014 16:47:15 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Mike Turquette <mturquette@linaro.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Antoine Tenart <antoine.tenart@free-electrons.com>,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] clk: berlin: add clock binding docs for Marvell
 Berlin2 SoCs
Message-ID: <20140513144715.GF29318@piout.net>
References: <1399839881-29895-1-git-send-email-sebastian.hesselbarth@gmail.com>
 <1399839881-29895-3-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399839881-29895-3-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

Not much to say,

On 11/05/2014 at 22:24:35 +0200, Sebastian Hesselbarth wrote :
> +* Single-register clock dividers
> +
> +Single-register clock dividers are complex divider cells, allowing
> +to divide a reference clock with a set of fixed dividers. Also they
> +comprise and input clock mux with bypass and an ouput clock gate.
typo here-----^

> +
> +Required properties:
> +- compatible: shall be "marvell,berlin2-clk-div"
> +- reg: address and length of the corresponding DIV registers
> +- #clock-cells: shall be set to 0
> +- clocks: clock specifiers referencing the DIV input clocks
> +- clock-names: array of strings describing the clock specifiers above.
> +    Allowed clock-names are "mux_bypass" for the clock mux bypass selection
> +    and "muxN" (N=0..7) for each of the 8 possible clock mux inputs.
> +

-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
