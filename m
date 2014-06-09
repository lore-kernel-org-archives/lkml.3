Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932131AbaFIVul (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 17:50:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45083 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754218AbaFIVui (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 17:50:38 -0400
Message-ID: <53962C2C.9030802@suse.cz>
Date: Mon, 09 Jun 2014 23:50:36 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Himangi Saraogi <himangi774@gmail.com>
CC: linux-kernel@vger.kernel.org, kbuild@01.org, julia.lawall@lip6.fr,
        Gilles Muller <Gilles.Muller@lip6.fr>,
        Nicolas Palix <nicolas.palix@imag.fr>,
        "cocci@systeme.lip6.fr" <cocci@systeme.lip6.fr>
Subject: Re: [PATCH] coccinelle/null: solve parse error
References: <20140528141047.GA4059@himangi-Dell>
In-Reply-To: <20140528141047.GA4059@himangi-Dell>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added the rest of the coccinelle gang to cc)

Dne 28.5.2014 16:10, Himangi Saraogi napsal(a):
> This patch solves the parse-error by adding @@ . This is necessary since
> Coccinelle version 1.0.0-rc20. Also, the comment is added to use a
> recent version of Coccinelle.
> 
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> ---
>  scripts/coccinelle/null/badzero.cocci | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/scripts/coccinelle/null/badzero.cocci b/scripts/coccinelle/null/badzero.cocci
> index d79baf7..5551da2 100644
> --- a/scripts/coccinelle/null/badzero.cocci
> +++ b/scripts/coccinelle/null/badzero.cocci
> @@ -10,7 +10,7 @@
>  // Copyright: (C) 2012 Julia Lawall, INRIA/LIP6.  GPLv2.
>  // Copyright: (C) 2012 Gilles Muller, INRIA/LiP6.  GPLv2.
>  // URL: http://coccinelle.lip6.fr/
> -// Comments:
> +// Comments: Requires Coccinelle version 1.0.0-rc20 or later
>  // Options:
>  
>  virtual patch
> @@ -19,6 +19,7 @@ virtual org
>  virtual report
>  
>  @initialize:ocaml@
> +@@
>  let negtable = Hashtbl.create 101
>  
>  @depends on patch@
> 

