Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab3FJJWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 05:22:51 -0400
Received: from mail-bk0-f52.google.com ([209.85.214.52]:55211 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3FJJWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 05:22:43 -0400
Message-ID: <1370856152.3252.2.camel@edumazet-glaptop>
Subject: Re: [PATCH v10 net-next 1/6] net: add napi_id and hash
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
Date: Mon, 10 Jun 2013 02:22:32 -0700
In-Reply-To: <20130610083940.6955.67403.stgit@ladj378.jer.intel.com>
References: <20130610083929.6955.87206.stgit@ladj378.jer.intel.com>
	 <20130610083940.6955.67403.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-10 at 11:39 +0300, Eliezer Tamir wrote:
> Adds a napi_id and a hashing mechanism to lookup a napi by id.
> This will be used by subsequent patches to implement low latency
> Ethernet device polling.
> Based on a code sample by Eric Dumazet.
> 
> Signed-off-by: Eliezer Tamir <eliezer.tamir@linux.intel.com>
> ---
> 
>  include/linux/netdevice.h |   29 ++++++++++++++++++++++
>  net/core/dev.c            |   59 +++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 88 insertions(+), 0 deletions(-)

Signed-off-by: Eric Dumazet <edumazet@google.com>


