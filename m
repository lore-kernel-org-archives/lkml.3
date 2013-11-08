Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab3KHK3D (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:29:03 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:65534 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756967Ab3KHK27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:28:59 -0500
Date: Fri, 8 Nov 2013 10:28:53 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        devicetree@vger.kernel.org, rob@landley.net
Subject: Re: [PATCH 1/1] Documentation/mfd: Fix typos in s2mps11.txt
Message-ID: <20131108102853.GV30901@lee--X1>
References: <1383634640-26869-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1383634640-26869-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As this is only a trivial patch, I'll take it out the hands of the
already overloaded DT maintainers.

> Fixed trivial typos to improve readability.
> 
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  Documentation/devicetree/bindings/mfd/s2mps11.txt |    9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/devicetree/bindings/mfd/s2mps11.txt b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> index c9332c6..0ff4e65 100644
> --- a/Documentation/devicetree/bindings/mfd/s2mps11.txt
> +++ b/Documentation/devicetree/bindings/mfd/s2mps11.txt
> @@ -1,10 +1,10 @@
>  
>  * Samsung S2MPS11 Voltage and Current Regulator
>  
> -The Samsung S2MP211 is a multi-function device which includes voltage and
> +The Samsung S2MPS11 is a multi-function device which includes voltage and

Nice catch eagle-eye!

>  current regulators, RTC, charger controller and other sub-blocks. It is
> -interfaced to the host controller using a I2C interface. Each sub-block is
> -addressed by the host system using different I2C slave address.
> +interfaced to the host controller using an I2C interface. Each sub-block is
> +addressed by the host system using different I2C slave addresses.
>  
>  Required properties:
>  - compatible: Should be "samsung,s2mps11-pmic".
> @@ -43,7 +43,8 @@ sub-node should be of the format as listed below.
>  
>   BUCK[2/3/4/6] supports disabling ramp delay on hardware, so explictly
>   regulator-ramp-delay = <0> can be used for them to disable ramp delay.
> - In absence of regulator-ramp-delay property, default ramp delay will be used.
> + In the absence of regulator-ramp-delay property, default ramp delay will
> + be used.

So if we're being pertinacity here, your correction isn't much better.

s/of regulator-ramp-delay property,/of {the,an} regulator-ramp-delay property, the

or 

s/of regulator-ramp-delay property,/of regulator-ramp-delay, the

>  NOTE: Some BUCKs share the ramp rate setting i.e. same ramp value will be set
>  for a particular group of BUCKs. So provide same regulator-ramp-delay<value>.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
