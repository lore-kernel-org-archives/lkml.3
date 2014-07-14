Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487AbaGNWbI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:31:08 -0400
Received: from mail-qc0-f176.google.com ([209.85.216.176]:55006 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757252AbaGNWbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:31:03 -0400
From: Paul Moore <paul@paul-moore.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, joe@perches.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH 05/16] netlabel: remove unnecessary break after goto
Date: Mon, 14 Jul 2014 18:30:58 -0400
Message-ID: <1736644.xDSijyH7JM@sifl>
User-Agent: KMail/4.13.2 (Linux/3.14.8-gentoo; KDE/4.13.2; x86_64; ; )
In-Reply-To: <1405355467-7350-6-git-send-email-fabf@skynet.be>
References: <1405355467-7350-1-git-send-email-fabf@skynet.be> <1405355467-7350-6-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, July 14, 2014 06:30:55 PM Fabian Frederick wrote:
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Acked-by: Paul Moore <paul@paul-moore.com>

> ---
>  net/netlabel/netlabel_kapi.c | 1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> index 3045a96..fe9415e 100644
> --- a/net/netlabel/netlabel_kapi.c
> +++ b/net/netlabel/netlabel_kapi.c
> @@ -170,7 +170,6 @@ int netlbl_cfg_unlbl_map_add(const char *domain,
>  #endif /* IPv6 */
>  		default:
>  			goto cfg_unlbl_map_add_failure;
> -			break;
>  		}
> 
>  		entry->def.addrsel = addrmap;

-- 
paul moore
www.paul-moore.com

