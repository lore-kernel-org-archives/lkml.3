Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab3FENX0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jun 2013 09:23:26 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:65151 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543Ab3FENXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jun 2013 09:23:24 -0400
Message-ID: <1370438602.24311.243.camel@edumazet-glaptop>
Subject: Re: [PATCH v9 net-next 2/7] net: add low latency socket poll
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
Date: Wed, 05 Jun 2013 06:23:22 -0700
In-Reply-To: <20130605103421.11172.82925.stgit@ladj378.jer.intel.com>
References: <20130605103400.11172.49099.stgit@ladj378.jer.intel.com>
	 <20130605103421.11172.82925.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 13:34 +0300, Eliezer Tamir wrote:
> Adds an ndo_ll_poll method and the code that supports it.
> This method can be used by low latency applications to busy-poll
> Ethernet device queues directly from the socket code.
> sysctl_net_ll_poll controls how many microseconds to poll.
> Default is zero (disabled).
> Individual protocol support will be added by subsequent patches.
> 
> Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
> Signed-off-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
> Tested-by: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---

Are you sure this version was tested by Willem ?

Acked-by: Eric Dumazet <edumazet@google.com>



