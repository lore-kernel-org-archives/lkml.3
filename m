Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239AbaICLsN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 07:48:13 -0400
Received: from smtprelay.synopsys.com ([198.182.60.111]:44629 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755478AbaICLsM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 07:48:12 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Noam Camus <noamc@ezchip.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: [PATCH] ARC: [mm] Fix compilation breakage
Thread-Topic: [PATCH] ARC: [mm] Fix compilation breakage
Thread-Index: AQHPx2wI3CdOl2DdS0y+ABWwfFF9ZA==
Date: Wed, 3 Sep 2014 11:48:06 +0000
Message-ID: <C2D7FE5348E1B147BCA15975FBA230753C5CF846@IN01WEMBXA.internal.synopsys.com>
References: <1409744471-3698-1-git-send-email-noamc@ezchip.com>
Accept-Language: en-US, en-IN
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.196.93]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 03 September 2014 05:11 PM, Noam Camus wrote:
> From: Noam Camus <noamc@ezchip.com>
>
> Structure name and variable name were erroneously interchanged
> Signed-off-by: Noam Camus <noamc@ezchip.com>

Acked-by: Vineet Gupta <vgupta@synopsys.com>

Linux, this was a brown paper bag on my part, please apply it to current 3.17-rc

Thx,
-Vineet

> ---
>  arch/arc/mm/cache_arc700.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/arc/mm/cache_arc700.c b/arch/arc/mm/cache_arc700.c
> index 4670afc..22df2d1 100644
> --- a/arch/arc/mm/cache_arc700.c
> +++ b/arch/arc/mm/cache_arc700.c
> @@ -427,7 +427,7 @@ struct ic_inv_args {
>  
>  static void __ic_line_inv_vaddr_helper(void *info)
>  {
> -        struct ic_inv *ic_inv_args = (struct ic_inv_args *) info;
> +        struct ic_inv_args *ic_inv = (struct ic_inv_args *) info;
>  
>          __ic_line_inv_vaddr_local(ic_inv->paddr, ic_inv->vaddr, ic_inv->sz);
>  }

