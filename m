Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751904AbaJPBSX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Oct 2014 21:18:23 -0400
Received: from na6sys009bog031.obsmtp.com ([74.125.150.105]:41418 "HELO
	na6sys009bog031.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751784AbaJPBSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Oct 2014 21:18:22 -0400
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Wed, 15 Oct 2014 21:18:21 EDT
MIME-Version: 1.0
In-Reply-To: <1413399798-8514-1-git-send-email-fabf@skynet.be>
References: <1413399798-8514-1-git-send-email-fabf@skynet.be>
Date: Wed, 15 Oct 2014 18:12:15 -0700
Message-ID: <CALnjE+qap-kXC6DaALqc0S=a8oNjyuEu8B-_8dBLQ3NtHr8Ytw@mail.gmail.com>
Subject: Re: [PATCH 1/1 net-next] openvswitch: kerneldoc warning fix
From: Pravin Shelar <pshelar@nicira.com>
To: Fabian Frederick <fabf@skynet.be>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "dev@openvswitch.org" <dev@openvswitch.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 15, 2014 at 12:03 PM, Fabian Frederick <fabf@skynet.be> wrote:
> s/sock/gs
>
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Looks good.

Acked-by: Pravin B Shelar <pshelar@nicira.com>

Thanks.

> ---
>  net/openvswitch/vport-geneve.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/openvswitch/vport-geneve.c b/net/openvswitch/vport-geneve.c
> index 910b3ef..106a9d8 100644
> --- a/net/openvswitch/vport-geneve.c
> +++ b/net/openvswitch/vport-geneve.c
> @@ -30,7 +30,7 @@
>
>  /**
>   * struct geneve_port - Keeps track of open UDP ports
> - * @sock: The socket created for this port number.
> + * @gs: The socket created for this port number.
>   * @name: vport name.
>   */
>  struct geneve_port {
> --
> 1.9.3
>
