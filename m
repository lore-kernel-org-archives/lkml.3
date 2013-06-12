Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675Ab3FLMoc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jun 2013 08:44:32 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:34612 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3FLMob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jun 2013 08:44:31 -0400
Message-ID: <1371041065.3252.59.camel@edumazet-glaptop>
Subject: Re: [PATCH v2 net-next 3/3] net: add socket option for low latency
 polling
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
        Alex Rosenbaum <alexr@mellanox.com>,
        Avner Ben Hanoch <avnerb@mellanox.com>, Or Kehati <ork@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Wed, 12 Jun 2013 05:44:25 -0700
In-Reply-To: <20130612112016.19288.86849.stgit@ladj378.jer.intel.com>
References: <20130612111942.19288.12131.stgit@ladj378.jer.intel.com>
	 <20130612112016.19288.86849.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-12 at 14:20 +0300, Eliezer Tamir wrote:
> adds a socket option for low latency polling.
> This allows overriding the global sysctl value with a per-socket one.
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---

It seems EXPORT_SYMBOL_GPL(sysctl_net_ll_poll) can now be removed ?



