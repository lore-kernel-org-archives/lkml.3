Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752045AbaFEHvs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 03:51:48 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:47635 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaFEHvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 03:51:45 -0400
Date: Thu, 5 Jun 2014 08:51:41 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Gabriel FERNANDEZ <gabriel.fernandez@st.com>
Cc: mturquette@linaro.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, devicetree@vger.kernel.org, kernel@stlinux.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Gabriel Fernandez <gabriel.fernandez@linaro.org>,
        Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org
Subject: Re: [STLinux Kernel] [PATCH RESEND 02/12] clk: st: Adds Flexgen
 clock binding
Message-ID: <20140605075141.GB3865@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1401892320-18211-1-git-send-email-gabriel.fernandez@linaro.org>
 <1401892320-18211-3-git-send-email-gabriel.fernandez@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1401892320-18211-3-git-send-email-gabriel.fernandez@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gabi,

> +Example:
> +
> +	clockgenD2@x9106000 {
> +		compatible = "st,clkgen-c32";
> +		reg = <0x9106000 0x1000>;
> +
> +		CLK_S_D2_FLEXGEN: CLK_S_D2_FLEXGEN {
> +			compatible = "st,flexgen";
> +
> +			#clock-cells = <1>;
> +			clocks = <&CLK_S_D2_QUADFS 0>,
> +				 <&CLK_S_D2_QUADFS 1>,
> +				 <&CLK_S_D2_QUADFS 2>,
> +				 <&CLK_S_D2_QUADFS 3>;
> +
> +			clock-output-names = "CLK_PIX_MAIN_DISP",
> +					     "CLK_PIX_PIP",
> +					     "CLK_PIX_GDP1",
> +					     "CLK_PIX_GDP2";

With the upper case to lower case renaming of the STI device tree
this example also needs to be converted to lower case names 
throughout.

Once rectified you can add my:
 Acked-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter.

