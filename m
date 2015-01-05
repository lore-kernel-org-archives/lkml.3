Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168AbbAEUkf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 15:40:35 -0500
Received: from mail-la0-f50.google.com ([209.85.215.50]:59626 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186AbbAEUkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 15:40:32 -0500
Message-ID: <54AAF6B9.6050703@cogentembedded.com>
Date: Mon, 05 Jan 2015 23:40:25 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Organization: Cogent Embedded
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: mturquette@linaro.org, linux-kernel@vger.kernel.org, sboyd@codeaurora.org
CC: linux-sh@vger.kernel.org, vksavl@gmail.com, robh+dt@kernel.org,
        pawel.moll@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v3] clk-rcar-gen2: RCAN clock support
References: <1678262.gW7XrkflEf@wasted.cogentembedded.com>
In-Reply-To: <1678262.gW7XrkflEf@wasted.cogentembedded.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/05/2015 11:10 PM, Sergei Shtylyov wrote:

> Add the RCAN clock support to the R-Car generation 2 CPG driver.  This clock
> gets derived from  the USB_EXTAL clock, dividing  it by 6.  The layout of the
> RCANCKCR register is similar to those of the clocks supported by the 'clk-div6'
> driver but has no divider field, and so can't be supported by that driver...

> Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

[...]

> Index: renesas/Documentation/devicetree/bindings/clock/renesas,rcar-gen2-cpg-clocks.txt
> ===================================================================
> --- renesas.orig/Documentation/devicetree/bindings/clock/renesas,rcar-gen2-cpg-clocks.txt
> +++ renesas/Documentation/devicetree/bindings/clock/renesas,rcar-gen2-cpg-clocks.txt

    It should have been against Mike's tree. And forgot to add Geert's ACK. 
Ignore this one, I'll repost.

WBR, Sergei

