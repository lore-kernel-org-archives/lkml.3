Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758027Ab3CGAHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 19:07:22 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:39747 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757950Ab3CGAHS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 19:07:18 -0500
Message-ID: <1362614837.2093.30.camel@joe-AO722>
Subject: Re: [PATCH] CAIF: fix indentation for function arguments
From: Joe Perches <joe@perches.com>
To: Silviu-Mihai Popescu <silviupopescu1990@gmail.com>
Cc: netdev@vger.kernel.org, sjur.brandeland@stericsson.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Date: Wed, 06 Mar 2013 16:07:17 -0800
In-Reply-To: <1362606521-16848-1-git-send-email-silviupopescu1990@gmail.com>
References: <1362606521-16848-1-git-send-email-silviupopescu1990@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-03-06 at 23:48 +0200, Silviu-Mihai Popescu wrote:
> This lines up function arguments on second and subsequent lines at the
> first column after the openning parenthesis of the first line.
[]
> diff --git a/net/caif/caif_dev.c b/net/caif/caif_dev.c
[]
> @@ -301,10 +301,10 @@ static void dev_flowctrl(struct net_device *dev, int on)
>  }
>  
>  void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
> -			struct cflayer *link_support, int head_room,
> -			struct cflayer **layer, int (**rcv_func)(
> -				struct sk_buff *, struct net_device *,
> -				struct packet_type *, struct net_device *))
> +		     struct cflayer *link_support, int head_room,
> +		     struct cflayer **layer, int (**rcv_func)(
> +		     struct sk_buff *, struct net_device *,
> +		     struct packet_type *, struct net_device *))

This makes it seem that caif_enroll_dev takes more args.

I think this style is better (aligned to appropriate open paren)

void caif_enroll_dev(struct net_device *dev, struct caif_dev_common *caifdev,
		     struct cflayer *link_support, int head_room,
		     struct cflayer **layer,
		     int (**rcv_func)(struct sk_buff *, struct net_device *,
				      struct packet_type *, struct net_device *))

[]

> @@ -301,8 +301,8 @@ static int caif_connect_req_to_link_param(struct cfcnfg *cnfg,
>  
>  int caif_connect_client(struct net *net, struct caif_connect_request *conn_req,
>  			struct cflayer *adap_layer, int *ifindex,
> -				int *proto_head,
> -				int *proto_tail)
> +			int *proto_head,
> +			int *proto_tail)

You could fill to 80 here.


