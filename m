Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758623Ab3HMTOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 15:14:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:58947 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757824Ab3HMTOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 15:14:34 -0400
Message-ID: <520A8596.5000608@wwwdotorg.org>
Date: Tue, 13 Aug 2013 13:14:30 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: broonie@kernel.org, sameo@linux.intel.com, rob.herring@calxeda.com,
        pawel.moll@arm.com, mark.rutland@arm.com, rob@landley.net,
        lee.jones@linaro.org, grant.likely@linaro.org,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, gg@slimlogic.co.uk, kishon@ti.com,
        j-keerthy@ti.com, ian.campbell@citrix.com
Subject: Re: [PATCH V2 1/3] regulator: palmas: Update the DT binding doc for
 smps10 out1 and out2
References: <1376380392-19723-1-git-send-email-ldewangan@nvidia.com> <1376380392-19723-2-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1376380392-19723-2-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2013 01:53 AM, Laxman Dewangan wrote:
> Palmas regulator SMPS10 is splitted into two regulators SMPS10-OUT1 and
> SMPS10-OUT2 to match with hw behavior. With this regulator's name got
> changed in driver.
> 
> Update the DT binding document to match with driver.

> diff --git a/Documentation/devicetree/bindings/regulator/palmas-pmic.txt b/Documentation/devicetree/bindings/regulator/palmas-pmic.txt

>  	       For ti,palmas-pmic - smps12, smps123, smps3 depending on OTP,
> -	       smps45, smps457, smps7 depending on variant, smps6, smps[8-10],
> -	       ldo[1-9], ldoln, ldousb.
> +	       smps45, smps457, smps7 depending on variant, smps6, smps[8-9],
> +	       smps10_out2, smps10_out1, do[1-9], ldoln, ldousb.

Oh sorry, I commented on V1 without noticing V2. You still need to
s/do/ldo/ here I think...

