Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028AbaFBKon (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jun 2014 06:44:43 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:40947 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752858AbaFBKol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jun 2014 06:44:41 -0400
Date: Mon, 2 Jun 2014 11:44:05 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Antoine =?utf-8?Q?T=C3=A9nart?= 
	<antoine.tenart@free-electrons.com>
Cc: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        "zmxu@marvell.com" <zmxu@marvell.com>,
        "jszhang@marvell.com" <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] Documentation: bindings: document the Marvell Berlin
 enable-method
Message-ID: <20140602104405.GB13573@leverpostej>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
 <1401700866-24804-3-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1401700866-24804-3-git-send-email-antoine.tenart@free-electrons.com>
Thread-Topic: [PATCH 2/5] Documentation: bindings: document the Marvell
 Berlin enable-method
Accept-Language: en-GB, en-US
Content-Language: en-US
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 02, 2014 at 10:21:03AM +0100, Antoine Ténart wrote:
> The SMP support for Marvell Berlin SoCs introduce a new enable-method.
> Document it.
> 
> Signed-off-by: Antoine Ténart <antoine.tenart@free-electrons.com>
> ---
>  Documentation/devicetree/bindings/arm/cpus.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 333f4aea3029..50ec9ae6de28 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -185,6 +185,7 @@ nodes to be present and contain the properties described below.
>  			    "qcom,gcc-msm8660"
>  			    "qcom,kpss-acc-v1"
>  			    "qcom,kpss-acc-v2"
> +			    "marvell,berlin-smp"

And what does this mean?

The existing bindings are ambiguous enough. It would be nice to have a
proper document describing the method, as Alex Elder is trying to sort
out for the existing bindings.

Cheers,
Mark.
