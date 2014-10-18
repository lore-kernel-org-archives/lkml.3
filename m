Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751666AbaJRABL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 20:01:11 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35804 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbaJRABJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 20:01:09 -0400
Message-ID: <5441ADBA.1070800@linux.vnet.ibm.com>
Date: Fri, 17 Oct 2014 19:00:58 -0500
From: Nathan Fontenot <nfont@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Dan Streetman <ddstreet@ieee.org>, Michael Ellerman <mpe@ellerman.id.au>,
        benh@kernel.crashing.org
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: nx-842 driver maintainer change
References: <1413587999-12684-1-git-send-email-ddstreet@ieee.org>
In-Reply-To: <1413587999-12684-1-git-send-email-ddstreet@ieee.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14101800-0033-0000-0000-0000025EF152
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2014 06:19 PM, Dan Streetman wrote:
> Change maintainer of nx-842 compression coprocessor driver
> to Dan Streetman.
> 
> Signed-off-by: Dan Streetman <ddstreet@ieee.org>
> Cc: Nathan Fontenot <nfont@linux.vnet.ibm.com>

Acked-by: Nathan Fontenot <nfont@linux.vnet.ibm.com>

> ---
>  MAINTAINERS | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b0f17d5..3cc3e41 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -4605,7 +4605,7 @@ S:	Supported
>  F:	drivers/crypto/nx/
> 
>  IBM Power 842 compression accelerator
> -M:	Nathan Fontenot <nfont@linux.vnet.ibm.com>
> +M:	Dan Streetman <ddstreet@us.ibm.com>
>  S:	Supported
>  F:	drivers/crypto/nx/nx-842.c
>  F:	include/linux/nx842.h
> 

