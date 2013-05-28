Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab3E1Afo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 May 2013 20:35:44 -0400
Received: from mail-pb0-f54.google.com ([209.85.160.54]:35276 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752972Ab3E1Afm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 May 2013 20:35:42 -0400
Message-ID: <1369701340.3301.504.camel@edumazet-glaptop>
Subject: Re: [PATCH v5 net-next 0/5] net: low latency Ethernet device polling
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Eliezer Tamir <eliezer.tamir@linux.intel.com>
Cc: Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eilon Greenstien <eilong@broadcom.com>,
        Or Gerlitz <or.gerlitz@gmail.com>, Alex Rosenbaum <alexr@mellanox.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Date: Mon, 27 May 2013 17:35:40 -0700
In-Reply-To: <20130527074351.29882.51106.stgit@ladj378.jer.intel.com>
References: <20130527074351.29882.51106.stgit@ladj378.jer.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-05-27 at 10:43 +0300, Eliezer Tamir wrote:
> Hello Dave,
> 
> There are many small changes from the last time.
> The two big changes are:
> * Skb and sk now store a napi_id instead of a pointer.
> * Very naive poll/select support. There is a dramatic improvement in both
>   latencey and jitter, but clearly more work needs to be done here.

Sorry I couldn't figure out how poll() was supported.


