Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901Ab3ETNtG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 09:49:06 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:51173 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756270Ab3ETNtE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 09:49:04 -0400
Message-ID: <1369057742.3301.168.camel@edumazet-glaptop>
Subject: Re: [PATCH v3 net-next 2/4] tcp: add TCP support for low latency
 receive poll.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 20 May 2013 06:49:02 -0700
In-Reply-To: <20130520101612.14133.95780.stgit@ladj378.jer.intel.com>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
	 <20130520101612.14133.95780.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-20 at 13:16 +0300, Eliezer Tamir wrote:
>  
> +config INET_LL_TCP_POLL
> +	bool "Low Latency TCP Receive Poll"
> +	depends on INET_LL_RX_POLL
> +	default n
> +	---help---
> +	  TCP support for Low Latency TCP Queue Poll.
> +	  (For network cards that support this option.)
> +	  Add support to the TCP stack for direct polling of the network card.
> +
> +	  If unsure, say N.
> +

Oh well, code is small and already guarded by CONFIG_INET_LL_RX_POLL



