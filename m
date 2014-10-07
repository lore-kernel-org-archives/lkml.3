Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205AbaJGWNi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 18:13:38 -0400
Received: from mail-vc0-f172.google.com ([209.85.220.172]:36586 "EHLO
	mail-vc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895AbaJGWNh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 18:13:37 -0400
From: Paul Moore <paul@paul-moore.com>
To: Fabian Frederick <fabf@skynet.be>, "David S. Miller" <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] netlabel: kernel-doc warning fix
Date: Tue, 07 Oct 2014 18:13:34 -0400
Message-ID: <18856194.K9PbrNbEaI@sifl>
User-Agent: KMail/4.14.1 (Linux/3.16.1-gentoo; KDE/4.14.1; x86_64; ; )
In-Reply-To: <1412713892-5537-1-git-send-email-fabf@skynet.be>
References: <1412713892-5537-1-git-send-email-fabf@skynet.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, October 07, 2014 10:31:32 PM Fabian Frederick wrote:
> no secid argument in netlbl_cfg_unlbl_static_del
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Thanks.  Likely a copy/paste error from netlbl_cfg_unlbl_static_add().

Acked-by: Paul Moore <paul@paul-moore.com>

> ---
>  net/netlabel/netlabel_kapi.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/net/netlabel/netlabel_kapi.c b/net/netlabel/netlabel_kapi.c
> index 0b4692d..a845cd4 100644
> --- a/net/netlabel/netlabel_kapi.c
> +++ b/net/netlabel/netlabel_kapi.c
> @@ -246,7 +246,6 @@ int netlbl_cfg_unlbl_static_add(struct net *net,
>   * @addr: IP address in network byte order (struct in[6]_addr)
>   * @mask: address mask in network byte order (struct in[6]_addr)
>   * @family: address family
> - * @secid: LSM secid value for the entry
>   * @audit_info: NetLabel audit information
>   *
>   * Description:

-- 
paul moore
www.paul-moore.com

