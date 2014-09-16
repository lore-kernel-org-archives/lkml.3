Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755426AbaIPSyr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 14:54:47 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35951 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755154AbaIPSyo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 14:54:44 -0400
Date: Tue, 16 Sep 2014 19:54:39 +0100
From: Mark Rutland <mark.rutland@arm.com>
To: Kever Yang <kever.yang@rock-chips.com>
Cc: "heiko@sntech.de" <heiko@sntech.de>,
        "dianders@chromium.org" <dianders@chromium.org>,
        "sonnyrao@chromium.org" <sonnyrao@chromium.org>,
        "addy.ke@rock-chips.com" <addy.ke@rock-chips.com>,
        "cf@rock-chips.com" <cf@rock-chips.com>,
        "xjq@rock-chips.com" <xjq@rock-chips.com>,
        "hj@rock-chips.com" <hj@rock-chips.com>,
        "huangtao@rock-chips.com" <huangtao@rock-chips.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <Pawel.Moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Jason Cooper <jason@lakedaemon.net>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Olof Johansson <olof@lixom.net>,
        Lorenzo Pieralisi <Lorenzo.Pieralisi@arm.com>,
        Rohit Vaswani <rvaswani@codeaurora.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] Documentation: dt-bindings: add dt binding info
 for rk3288-smp
Message-ID: <20140916185439.GF14191@leverpostej>
References: <1410864271-9277-1-git-send-email-kever.yang@rock-chips.com>
 <1410864271-9277-2-git-send-email-kever.yang@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1410864271-9277-2-git-send-email-kever.yang@rock-chips.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 16, 2014 at 11:44:28AM +0100, Kever Yang wrote:
> This add documentation for rk3288 smp dt binding
> 
> Signed-off-by: Kever Yang <kever.yang@rock-chips.com>
> ---
> 
> Changes in v2:
> - add documentation
> 
>  Documentation/devicetree/bindings/arm/cpus.txt | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/arm/cpus.txt b/Documentation/devicetree/bindings/arm/cpus.txt
> index 298e2f6..4b46233 100644
> --- a/Documentation/devicetree/bindings/arm/cpus.txt
> +++ b/Documentation/devicetree/bindings/arm/cpus.txt
> @@ -195,6 +195,7 @@ nodes to be present and contain the properties described below.
>  			    "qcom,kpss-acc-v1"
>  			    "qcom,kpss-acc-v2"
>  			    "rockchip,rk3066-smp"
> +			    "rockchip,rk3288-smp"

How do these differ?

What does "rockchip,rk3288-smp" mean exactly?

Presumably other nodes / properties are required?

Mark.
