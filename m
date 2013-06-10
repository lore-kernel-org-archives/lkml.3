Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753267Ab3FJOch (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 10:32:37 -0400
Received: from mail-gg0-f179.google.com ([209.85.161.179]:35503 "EHLO
	mail-gg0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172Ab3FJOcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 10:32:36 -0400
Message-ID: <1370874744.3252.5.camel@edumazet-glaptop>
Subject: Re: [PATCH v10 net-next 4/6] tcp: add low latency socket poll
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
Date: Mon, 10 Jun 2013 07:32:24 -0700
In-Reply-To: <20130610084010.6955.14413.stgit@ladj378.jer.intel.com>
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
	 <20130610084010.6955.14413.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 11:40 +0300, Eliezer Tamir wrote:
> Adds low latency socket poll support for TCP.
> In tcp_v[46]_rcv() add a call to sk_mark_ll() to copy the napi_id
> from the skb to the sk.
> In tcp_recvmsg(), when there is no data in the socket we busy-poll.
> This is a good example of how to add busy-poll support to more protocols.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---

Acked-by: Eric Dumazet <edumazet@google.com>


