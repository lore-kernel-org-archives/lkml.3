Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420AbaFLA7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 20:59:31 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:57011 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaFLA72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 20:59:28 -0400
Date: Thu, 12 Jun 2014 09:59:24 +0900
From: Simon Horman <horms@verge.net.au>
To: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Cc: Rob Herring <robh@kernel.org>, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@kernel.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Magnus <magnus.damm@gmail.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>
Subject: Re: [PATCH] of: Add vendor 2nd prefix for Asahi Kasei Corp
Message-ID: <20140612005922.GE11549@verge.net.au>
References: <CAMuHMdWTVBjFzA9L9Eqpq_2Xi9_NHkOCLrb_UjK611SBfwnc=Q@mail.gmail.com>
 <87ioo7c0g5.wl%kuninori.morimoto.gx@renesas.com>
 <539815E6.2050304@codethink.co.uk>
 <20140611165410.GK5099@sirena.org.uk>
 <CAMuHMdUT0hEBGbN+W-Oz5zJ0N8S2VDMndqtDO=EtWF3jG2MEew@mail.gmail.com>
 <20140611170233.GL5099@sirena.org.uk>
 <5398A53D.3020706@wwwdotorg.org>
 <20140611190444.GN5099@sirena.org.uk>
 <5398AB07.4040304@wwwdotorg.org>
 <87sinbdk44.wl%kuninori.morimoto.gx@renesas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sinbdk44.wl%kuninori.morimoto.gx@renesas.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 11, 2014 at 05:53:02PM -0700, Kuninori Morimoto wrote:
> From: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
> 
> Current vendor-prefixes.txt already has
> "ak" prefix for Asahi Kasei Corp by
> ae8c4209af2cec065fef15d200a42a04130799f7
> (of: Add vendor prefix for Asahi Kasei Corp.)
> 
> It went through the appropriate review process,
> and is already in use.
> But, almost all Asahi Kasei chip driver is
> using "asahi-kasei" prefix today.
> 
> Due to ABIness, this patch adds
> "asahi-kasei" to vendor-prefixes.txt.
> checkpatch.pl will report WARNING without this patch.
> (DT compatible string vendor "asahi-kasei" appears un-documented)
> 
> OTOH, Asahi Kasei is usually referred as "AKM",
> but this patch doesn't care about it.
> Because no DT is using it today.
> 
> Cc: Stephen Warren <swarren@wwwdotorg.org>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
> Signed-off-by: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>

Acked-by: Simon Horman <horms+renesas@verge.net.au>

> ---
>  .../devicetree/bindings/vendor-prefixes.txt        |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index abc3080..7e4bb83 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -17,6 +17,7 @@ amstaos	AMS-Taos Inc.
>  apm	Applied Micro Circuits Corporation (APM)
>  arm	ARM Ltd.
>  armadeus	ARMadeus Systems SARL
> +asahi-kasei	Asahi Kasei Corp.
>  atmel	Atmel Corporation
>  auo	AU Optronics Corporation
>  avago	Avago Technologies
> -- 
> 1.7.9.5
> 
