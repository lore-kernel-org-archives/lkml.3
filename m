Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754102AbaGQSWY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2014 14:22:24 -0400
Received: from na3sys009aog129.obsmtp.com ([74.125.149.142]:38996 "HELO
	na3sys009aog129.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752709AbaGQSWX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2014 14:22:23 -0400
MIME-Version: 1.0
In-Reply-To: <1405584370-30054-9-git-send-email-teg@jklm.no>
References: <1405584370-30054-1-git-send-email-teg@jklm.no>
	<1405584370-30054-9-git-send-email-teg@jklm.no>
Date: Thu, 17 Jul 2014 11:22:22 -0700
Message-ID: <CALnjE+pK7bT=EmRT-zeL7thUUqgu-a66kwPK+7TT4cgKqjT1VA@mail.gmail.com>
Subject: Re: [PATCH net-next v9 8/9] net: openvswitch - set name assign type
From: Pravin Shelar <pshelar@nicira.com>
To: Tom Gundersen <teg@jklm.no>
Cc: netdev <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "dev@openvswitch.org" <dev@openvswitch.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 1:06 AM, Tom Gundersen <teg@jklm.no> wrote:
> Signed-off-by: Tom Gundersen <teg@jklm.no>
> Cc: Pravin Shelar <pshelar@nicira.com>
> Cc: dev@openvswitch.org
Looks good.

Acked-by: Pravin B Shelar <pshelar@nicira.com>

> ---
>
> v9: set NET_NAME_USER directly in internal_dev_create as requested by Pravin Shelar
>
>  net/openvswitch/vport-internal_dev.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/vport-internal_dev.c b/net/openvswitch/vport-internal_dev.c
> index bd65855..2741285 100644
> --- a/net/openvswitch/vport-internal_dev.c
> +++ b/net/openvswitch/vport-internal_dev.c
> @@ -165,7 +165,7 @@ static struct vport *internal_dev_create(const struct vport_parms *parms)
>         netdev_vport = netdev_vport_priv(vport);
>
>         netdev_vport->dev = alloc_netdev(sizeof(struct internal_dev),
> -                                        parms->name, NET_NAME_UNKNOWN,
> +                                        parms->name, NET_NAME_USER,
>                                          do_setup);
>         if (!netdev_vport->dev) {
>                 err = -ENOMEM;
> --
> 1.9.3
>
