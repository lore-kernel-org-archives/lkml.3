Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932470Ab3DYOQw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 10:16:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757104Ab3DYOQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 10:16:50 -0400
Date: Thu, 25 Apr 2013 16:16:48 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trivial: fix some then vs. than typos
In-Reply-To: <Pine.LNX.4.64.1304171048390.12878@axis700.grange>
Message-ID: <alpine.LNX.2.00.1304251615020.29143@pobox.suse.cz>
References: <Pine.LNX.4.64.1304171048390.12878@axis700.grange>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Apr 2013, Guennadi Liakhovetski wrote:

> This patch fixes some of the obvious then vs. than typos.
> 
> Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
[ ... snip ... ]
> --- a/Documentation/usb/mass-storage.txt
> +++ b/Documentation/usb/mass-storage.txt
> @@ -121,7 +121,7 @@
>      capped.
>  
>      If this parameter is provided, and the number of files specified
> -    in â??fileâ?? argument is greater then the value of â??lunsâ??, all excess
> +    in â??fileâ?? argument is greater than the value of â??lunsâ??, all excess

UTF8 encoding problem?

> --- a/arch/blackfin/lib/udivsi3.S
> +++ b/arch/blackfin/lib/udivsi3.S
> @@ -66,7 +66,7 @@ ENTRY(___udivsi3)
>  .Ly_16bit:
>    /* We know that the upper 17 bits of Y might have bits set,
>    ** or that the sign bit of X might have a bit. If Y is a
> -  ** 16-bit number, but not bigger, then we can use the builtins
> +  ** 16-bit number, but not bigger, than we can use the builtins

This change is wrong.

-- 
Jiri Kosina
SUSE Labs
