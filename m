Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752212AbaKQK0X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 05:26:23 -0500
Received: from mail-lb0-f182.google.com ([209.85.217.182]:45166 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752115AbaKQK0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 05:26:20 -0500
Message-ID: <5469CD47.3040409@cogentembedded.com>
Date: Mon, 17 Nov 2014 13:26:15 +0300
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
        Rob Herring <robh@kernel.org>
CC: Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
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
Subject: Re: [PATCH v4] of: replace Asahi Kasei Corp venter prefix
References: <878ulzx6hr.wl%kuninori.morimoto.gx@gmail.com>	<20140922130026.GK3290@leverpostej>	<CAMuHMdX22z97SbGS1HDiYfJ1PXxyEN2S8D7w4sr+4bUwD+mJZw@mail.gmail.com>	<20140922132743.GM3290@leverpostej>	<87y4rfhmgl.wl%kuninori.morimoto.gx@renesas.com>	<1415845309.4269.6.camel@perches.com>	<20141113025105.GA16652@verge.net.au>	<87vbmjhj00.wl%kuninori.morimoto.gx@renesas.com>	<20141113110740.GE3815@sirena.org.uk>	<87k32yd0bd.wl%kuninori.morimoto.gx@renesas.com>	<20141114093554.GC3810@ulmo> <87y4ra8xac.wl%kuninori.morimoto.gx@renesas.com>
In-Reply-To: <87y4ra8xac.wl%kuninori.morimoto.gx@renesas.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 11/17/2014 3:51 AM, Kuninori Morimoto wrote:

> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

    s/venter/vendor/ in the subject. Sorry for a late comment.

> Current vendor-prefixes.txt already has "ak" prefix for Asahi Kasei Corp
> by ae8c4209af2c(of: Add vendor prefix for Asahi Kasei Corp.)

> It went through the appropriate review process. But, almost all
> Asahi Kasei chip drivers are using "asahi-kasei" prefix today.
> (arch/arm/boot/dts/tegra20-seaboard.dts only is using "ak,ak8975",
>   but there are instances of "asahi-kasei,ak8975" in other dts files.
>   And drivers/iio/magnetometer/ak8975.c doesn't support "ak,ak8975")
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

    One normally places ACKs after his own sign-off.

WBR, Sergei

