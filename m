Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757718AbaFSIin (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 04:38:43 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:59890 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757608AbaFSIik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 04:38:40 -0400
Date: Thu, 19 Jun 2014 09:38:35 +0100
From: Peter Griffin <peter.griffin@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pwm@vger.kernel.org, kernel@stlinux.com,
        devicetree@vger.kernel.org, srinivas.kandagatla@gmail.com,
        thierry.reding@gmail.com
Subject: Re: [STLinux Kernel] [PATCH 1/7] ARM: stih407: Add DT nodes for for
 PWM
Message-ID: <20140619083835.GA2131@griffinp-ThinkPad-X1-Carbon-2nd>
References: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403103172-19856-1-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

> +		/* SBC PWM Module */
> +		pwm1: pwm@9510000 {
> +			compatible	= "st,sti-pwm";
> +			status		= "disabled";
> +			#pwm-cells	= <2>;
> +			reg		= <0x9510000 0x68>;
> +			pinctrl-names	= "default";
> +		        pinctrl-0	= <&pinctrl_pwm1_chan0_default
> +					&pinctrl_pwm1_chan1_default
> +					&pinctrl_pwm1_chan2_default
> +					&pinctrl_pwm1_chan3_default>;

If you're passing pin config for 4 channels, I think you should also be using the 
'st,pwm-num-chan = <4>' property like the doc example in patch 7.

After that: 
Acked-by: Peter Griffin <peter.griffin@linaro.org>

regards,

Peter. 

