Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966204Ab3E2Nii (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 09:38:38 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:35253 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966078Ab3E2Nig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 09:38:36 -0400
Message-ID: <1369834714.5109.16.camel@edumazet-glaptop>
Subject: Re: [PATCH v6 net-next 3/5] tcp: add TCP support for low latency
 receive poll.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 29 May 2013 06:38:34 -0700
In-Reply-To: <20130529063945.27486.61442.stgit@ladj378.jer.intel.com>
References: <20130529063916.27486.3841.stgit@ladj378.jer.intel.com>
	 <20130529063945.27486.61442.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-05-29 at 09:39 +0300, Eliezer Tamir wrote:
> Adds busy-poll support for TCP.
> Copy the napi_id from an incomming skb to the sk in tcp_v[46]_rcv().
> when there is no data in the socket we busy-poll in tcp_recvmsg().
> This is a good example of how to add busy-poll support to new protocols.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
> 
>  net/ipv4/tcp.c      |    5 +++++
>  net/ipv4/tcp_ipv4.c |    2 ++
>  net/ipv6/tcp_ipv6.c |    2 ++
>  3 files changed, 9 insertions(+), 0 deletions(-)

Acked-by: Eric Dumazet <edumazet@google.com>


