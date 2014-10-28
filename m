Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752572AbaJ1S37 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 14:29:59 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:26094
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751848AbaJ1S35 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 14:29:57 -0400
X-Greylist: delayed 581 seconds by postgrey-1.27 at vger.kernel.org; Tue, 28 Oct 2014 14:29:57 EDT
X-IronPort-AV: E=Sophos;i="5.04,804,1406584800"; 
   d="scan'208";a="85112223"
Date: Tue, 28 Oct 2014 19:20:10 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@hadrien
To: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
cc: Himangi Saraogi <himangi774@gmail.com>,
        Julia Lawall <julia.lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        cocci@systeme.lip6.fr, Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>, linux-kernel@vger.kernel.org
Subject: Re: bugon.cocci: fix Options at the macro
In-Reply-To: <20141028151824.4b41986f@recife.lan>
Message-ID: <alpine.DEB.2.10.1410281919500.2567@hadrien>
References: <20141028151824.4b41986f@recife.lan>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Thanks!
julia

On Tue, 28 Oct 2014, Mauro Carvalho Chehab wrote:

> The comma after --no-includes makes coccinelle to not run the script:
>
> /usr/bin/spatch -D report --very-quiet --no-show-diff --cocci-file ./scripts/coccinelle/misc/bugon.cocci --no-includes, --include-headers --patch . --dir drivers/media/platform/coda/ -I ./arch/x86/include -I arch/x86/include/generated -I include -I ./arch/x86/include/uapi -I arch/x86/include/generated/uapi -I ./include/uapi -I include/generated/uapi -I ./include/linux/kconfig.h
> Usage: spatch.opt --sp-file <SP> <infile> [-o <outfile>] [--iso-file <iso>] [options]
> Options are:
>   --sp-file                    <file> the semantic patch file
>   -o                           <file> the output file
>   --in-place                   do the modification on the file directly
>   --backup-suffix              suffix to use when making a backup for inplace
> ...
>
> At least with Fedora 20 coccinelle package:
> 	coccinelle-1.0.0-0.rc20.1.fc21.x86_64
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
>
> diff --git a/scripts/coccinelle/misc/bugon.cocci b/scripts/coccinelle/misc/bugon.cocci
> index 556456ca761c..3b7eec24fb5a 100644
> --- a/scripts/coccinelle/misc/bugon.cocci
> +++ b/scripts/coccinelle/misc/bugon.cocci
> @@ -8,7 +8,7 @@
>  // Confidence: High
>  // Copyright: (C) 2014 Himangi Saraogi.  GPLv2.
>  // Comments:
> -// Options: --no-includes, --include-headers
> +// Options: --no-includes --include-headers
>
>  virtual patch
>  virtual context
>
