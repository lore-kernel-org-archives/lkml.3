Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751321AbaK1LpL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 06:45:11 -0500
Received: from mail-lb0-f170.google.com ([209.85.217.170]:40419 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222AbaK1LpH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 06:45:07 -0500
Message-ID: <5478603D.1080404@cogentembedded.com>
Date: Fri, 28 Nov 2014 14:45:01 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Jason Cooper <jason@lakedaemon.net>, Heiko Stuebner <heiko@sntech.de>,
        Shawn Guo <shawn.guo@freescale.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Rob Herring <robh@kernel.org>, Mark Brown <broonie@kernel.org>
CC: Mark Rutland <mark.rutland@arm.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        linux-tegra@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Simon Horman <horms@verge.net.au>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Joe Perches <joe@perches.com>,
        Kuninori Morimoto <kuninori.morimoto.gx@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        "grant.likely@linaro.org" <grant.likely@linaro.org>
Subject: Re: [PATCH v5][resend] of: replace Asahi Kasei Corp venter prefix
References: <878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com>	<20140922130026.GK3290@leverpostej>	<CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>	<20140922132743.GM3290@leverpostej>	<87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>	<1415845309.4269.6.camel@perches.com>	<20141113025105.GA16652@verge.net.au>	<87vbmjhj00.wl%kuninori.morimoto.gx@renesas.com>	<20141113110740.GE3815@sirena.org.uk>	<87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com>	<20141114093554.GC3810@ulmo>	<87y4ra8xac.wl%kuninori.morimoto.gx@renesas.com>	<5469CD47.3040409@cogentembedded.com>	<877fytxsde.wl%kuninori.morimoto.gx@renesas.com> <87egsob2cl.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87egsob2cl.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/28/2014 3:22 AM, Kuninori Morimoto wrote:

> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

> Current vendor-prefixes.txt already has "ak" prefix for Asahi Kasei Corp
> by ae8c4209af2c(of: Add vendor prefix for Asahi Kasei Corp.)

> It went through the appropriate review process. But, almost all
> Asahi Kasei chip drivers are using "asahi-kasei" prefix today.
> (arch/arm/boot/dts/tegra20-seaboard.dts only is using "ak,ak8975",
>   but there are instances of "asahi-kasei,ak8975" in other dts files.
>   And drivers/iio/magnetometer/ak8975.c doesn't support "ak,ak8975" prefix)
> So, we made a mistake there.

> In addition, checkpatch.pl reports WARNING if it is using "asahi-kasei"
> prerfix in DT file.
> (DT compatible string vendor "asahi-kasei" appears un-documented)

> Marking it deprecated and warning with checkpatch is certainly
> preferable. So, this patch replace "ak" to "asahi-kasei" in
> vendor-prefixes.txt. (and fixup tegra20-seaboard)

> OTOH, Asahi Kasei is usually referred to as "AKM", but this patch
> doesn't care about it. Because no DT is using that today.

> Acked-by: Thierry Reding <treding@nvidia.com>
> Acked-by: Alexandre Courbot <acourbot@nvidia.com>
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

    It's "venter" ISO "vendor" again in the subject. And you already fixed 
that in the previous posting... :-)

WBR, Sergei

