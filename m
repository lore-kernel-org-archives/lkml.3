Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755140AbaGHS5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 14:57:05 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:33160
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754460AbaGHS5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 14:57:03 -0400
X-IronPort-AV: E=Sophos;i="5.01,626,1400018400"; 
   d="scan'208";a="70599060"
Date: Tue, 8 Jul 2014 20:56:29 +0200 (CEST)
From: Julia Lawall <julia.lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: Fabian Frederick <fabf@skynet.be>
cc: linux-kernel@vger.kernel.org, Julia Lawall <Julia.Lawall@lip6.fr>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/1 linux-next] scripts/coccinelle/free/ifnullfree.cocci:
 add copyright information
In-Reply-To: <1404835768-5229-1-git-send-email-fabf@skynet.be>
Message-ID: <alpine.DEB.2.02.1407082056160.2069@localhost6.localdomain6>
References: <1404835768-5229-1-git-send-email-fabf@skynet.be>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Acked-by: Julia Lawall <Julia.Lawall@lip6.fr>

On Tue, 8 Jul 2014, Fabian Frederick wrote:

> all coccinelle scripts have a copyright in the header ...
> 
> Suggested-By: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: Julia Lawall <Julia.Lawall@lip6.fr>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>
> ---
>  scripts/coccinelle/free/ifnullfree.cocci | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/coccinelle/free/ifnullfree.cocci b/scripts/coccinelle/free/ifnullfree.cocci
> index c826d98..9321fe3 100644
> --- a/scripts/coccinelle/free/ifnullfree.cocci
> +++ b/scripts/coccinelle/free/ifnullfree.cocci
> @@ -4,8 +4,9 @@
>  /// "kfree(NULL) is safe this check is probably not required"
>  /// and kfreeaddr.cocci by Julia Lawall.
>  ///
> -/// Comments: -
> -/// Options: --no-includes --include-headers
> +// Copyright: (C) 2014 Fabian Frederick.  GPLv2.
> +// Comments: -
> +// Options: --no-includes --include-headers
>  
>  virtual patch
>  virtual org
> -- 
> 1.8.4.5
> 
> 
