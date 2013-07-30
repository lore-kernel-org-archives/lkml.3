Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751266Ab3G3Kie (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 06:38:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49272 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750745Ab3G3Kid (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 06:38:33 -0400
Date: Tue, 30 Jul 2013 12:38:28 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Chen Gang <gang.chen@asianux.com>
Cc: jaharkes@cs.cmu.edu, coda@cs.cmu.edu, codalist@TELEMANN.coda.cs.cmu.edu,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH trivial] include/linux/coda.h: remove useless '#else'
In-Reply-To: <51F76B7D.2090602@asianux.com>
Message-ID: <alpine.LNX.2.00.1307301238230.18809@pobox.suse.cz>
References: <51F76B7D.2090602@asianux.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 30 Jul 2013, Chen Gang wrote:

> '#else' is useless, need remove.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> ---
>  include/linux/coda.h |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/include/linux/coda.h b/include/linux/coda.h
> index cff544f..d30209b 100644
> --- a/include/linux/coda.h
> +++ b/include/linux/coda.h
> @@ -60,7 +60,6 @@ Mellon the rights to redistribute these changes without encumbrance.
>  
>  #if defined(__linux__)
>  typedef unsigned long long u_quad_t;
> -#else
>  #endif
>  #include <uapi/linux/coda.h>
>  #endif 

Applied.

-- 
Jiri Kosina
SUSE Labs
