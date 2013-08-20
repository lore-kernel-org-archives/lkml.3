Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751335Ab3HTKpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 06:45:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46919 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab3HTKpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 06:45:52 -0400
Date: Tue, 20 Aug 2013 12:45:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Murilo Opsfelder Araujo <mopsfelder@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, rob@landley.net
Subject: Re: [PATCH] trivial: fix a typo in Documentation/00-INDEX
In-Reply-To: <1376959644-3242-1-git-send-email-mopsfelder@gmail.com>
Message-ID: <alpine.LNX.2.00.1308201245170.21654@pobox.suse.cz>
References: <1376959644-3242-1-git-send-email-mopsfelder@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Aug 2013, Murilo Opsfelder Araujo wrote:

> ---
>  Documentation/00-INDEX | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Documentation/00-INDEX b/Documentation/00-INDEX
> index 0c4cc68..38f8444 100644
> --- a/Documentation/00-INDEX
> +++ b/Documentation/00-INDEX
> @@ -40,7 +40,7 @@ IPMI.txt
>  IRQ-affinity.txt
>  	- how to select which CPU(s) handle which interrupt events on SMP.
>  IRQ-domain.txt
> -	- info on inerrupt numbering and setting up IRQ domains.
> +	- info on interrupt numbering and setting up IRQ domains.
>  IRQ.txt
>  	- description of what an IRQ is.
>  Intel-IOMMU.txt

Please resend your patch with proper Signed-off-by: line as documented in 
Documentation/SubmittingPatches, so that it could be applied.

Thanks,

-- 
Jiri Kosina
SUSE Labs
