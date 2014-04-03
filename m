Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162654AbaDCI3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 04:29:14 -0400
Received: from top.free-electrons.com ([176.31.233.9]:59965 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1162534AbaDCI3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 04:29:07 -0400
Date: Thu, 3 Apr 2014 10:29:03 +0200
From: Alexandre Belloni <alexandre.belloni@free-electrons.com>
To: Antoine =?iso-8859-1?Q?T=E9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: sebastian.hesselbarth@gmail.com, zmxu@marvell.com, jszhang@marvell.com,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: dts: document the berlin enable-method property
Message-ID: <20140403082903.GA4883@piout.net>
References: <1396512496-8030-1-git-send-email-antoine.tenart@free-electrons.com>
 <1396512496-8030-3-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1396512496-8030-3-git-send-email-antoine.tenart@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/04/2014 at 10:08:15 +0200, Antoine Ténart wrote :

Please write a quick commit message.

> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/arm/cpus.txt | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 333f4aea3029..a9e42a2dbc99 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -185,6 +185,8 @@ nodes to be present and contain the properties described below.
>  			    "qcom,gcc-msm8660"
>  			    "qcom,kpss-acc-v1"
>  			    "qcom,kpss-acc-v2"
> +			    "marvell,88de31-smp" - cpu-core handling for Berlin
> +					SoC from Marvell starting with 88de31

I would also go for something else, marvell,88de31xx-smp or marvell,berlin-smp.


-- 
Alexandre Belloni, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
