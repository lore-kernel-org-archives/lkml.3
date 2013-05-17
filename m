Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756078Ab3EQNkF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:40:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754085Ab3EQNkD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:40:03 -0400
Message-ID: <1368797996.28618.5.camel@t520.redhat.com>
Subject: Re: [PATCH 1/5] c6x: Wire up asm-generic/xor.h
From: Mark Salter <msalter@redhat.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org, linux-c6x-dev@linux-c6x.org
Date: Fri, 17 May 2013 09:39:56 -0400
In-Reply-To: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
References: <1368516726-8035-1-git-send-email-geert@linux-m68k.org>
Organization: Red Hat, Inc
Content-Type: text/plain; charset="us-ascii"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-05-14 at 09:32 +0200, Geert Uytterhoeven wrote:
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> Cc: Mark Salter <msalter@redhat.com>
> Cc: linux-c6x-dev@linux-c6x.org
> ---
> Completely untested due to lack of cross-compiler
> 
>  arch/c6x/include/asm/Kbuild |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
> index 4258b08..e49f918 100644
> --- a/arch/c6x/include/asm/Kbuild
> +++ b/arch/c6x/include/asm/Kbuild
> @@ -55,3 +55,4 @@ generic-y += types.h
>  generic-y += ucontext.h
>  generic-y += user.h
>  generic-y += vga.h
> +generic-y += xor.h

Acked-by: Mark Salter <msalter@redhat.com>
Tested-by: Mark Salter <msalter@redhat.com>



