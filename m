Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056AbaCSRdw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:33:52 -0400
Received: from mail-wg0-f51.google.com ([74.125.82.51]:47301 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733AbaCSRdv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:33:51 -0400
MIME-Version: 1.0
In-Reply-To: <1395237505-20550-2-git-send-email-dbaluta@ixiacom.com>
References: <1395237505-20550-1-git-send-email-dbaluta@ixiacom.com>
	<1395237505-20550-2-git-send-email-dbaluta@ixiacom.com>
Date: Wed, 19 Mar 2014 19:33:49 +0200
X-Google-Sender-Auth: 4IZJzZ26_WVypivz4E2unGcg3hM
Message-ID: <CAEnQRZAvziAo6CMZ2bhseHO_29zPPHvuQ2B+=z9Wn4gKPqnm6w@mail.gmail.com>
Subject: Re: [PATCH] net: remove empty lines from tcp_syn_flood_action
From: Daniel Baluta <dbaluta@ixiacom.com>
To: "David S. Miller" <davem@davemloft.net>
Cc: Daniel Baluta <dbaluta@ixiacom.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 3:58 PM, Daniel Baluta <dbaluta@ixiacom.com> wrote:
> Signed-off-by: Daniel Baluta <dbaluta@ixiacom.com>
> ---
>  net/ipv4/tcp_ipv4.c |    2 --
>  1 file changed, 2 deletions(-)
>
> diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
> index c4f1d9a..4555244 100644
> --- a/net/ipv4/tcp_ipv4.c
> +++ b/net/ipv4/tcp_ipv4.c
> @@ -880,8 +880,6 @@ bool tcp_syn_flood_action(struct sock *sk,
>         bool want_cookie = false;
>         struct listen_sock *lopt;
>
> -
> -
>  #ifdef CONFIG_SYN_COOKIES
>         if (sysctl_tcp_syncookies) {
>                 msg = "Sending cookies";

Sorry for the duplicate email.
