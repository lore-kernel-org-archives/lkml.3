Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758109Ab3ETUdK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 16:33:10 -0400
Received: from one.firstfloor.org ([193.170.194.197]:42182 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab3ETUdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 16:33:09 -0400
Date: Mon, 20 May 2013 22:33:07 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donald.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v3 net-next 3/4] ixgbe: Add support for ndo_ll_poll
Message-ID: <20130520203307.GE24555@two.firstfloor.org>
References: <20130520101552.14133.45953.stgit@ladj378.jer.intel.com>
 <20130520101622.14133.21998.stgit@ladj378.jer.intel.com>
 <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJZOPZJx8vpSWqOhmN65gn=vi7hWXQO_J01+hAwGY9RwetX3DA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> guys, so what is going here, you were asking to put this series in
> net-next, and you expect each other driver implementing this ndo to
> follow this undocumented hack? or maybe this code was just left here
> by mistake from previous implementations and just needed to be
> removed?  please clarify.

This is discussed in 0/x

-Andi
