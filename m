Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755440Ab3FENZ5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:25:57 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:54499 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab3FENZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:25:56 -0400
Message-ID: <1370438754.24311.245.camel@edumazet-glaptop>
Subject: Re: [PATCH v9 net-next 4/7] tcp: add low latency socket poll
 support.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: David Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Amir Vadai <amirv@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 05 Jun 2013 06:25:54 -0700
In-Reply-To: <20130605103441.11172.83787.stgit@ladj378.jer.intel.com>
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>
	 <20130605103441.11172.83787.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 13:34 +0300, Eliezer Tamir wrote:
> Adds low latency socket poll support for TCP.
> In tcp_v[46]_rcv() add a call to sk_mark_ll() to copy the napi_id
> from the skb to the sk.
> In tcp_recvmsg(), when there is no data in the socket we busy-poll.
> This is a good example of how to add busy-poll support to more protocols.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
Acked-by: Eric Dumazet <edumazet@google.com>


