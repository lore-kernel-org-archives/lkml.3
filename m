Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305AbaDNRyp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 13:54:45 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:37855 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754225AbaDNRyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 13:54:43 -0400
Message-ID: <1397498082.4222.29.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: [BUG] A panic caused by null pointer dereference aftering
 updating to
From: Eric Dumazet <eric.dumazet@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: nasa4836@gmail.com, jchapman@katalix.com, edumazet@google.com,
        joe@perches.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Date: Mon, 14 Apr 2014 10:54:42 -0700
In-Reply-To: <20140414.134901.2191404761213317963.davem@davemloft.net>
References: <1397495549.4222.26.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140414.133417.308357592624654107.davem@davemloft.net>
	 <1397497204.4222.28.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20140414.134901.2191404761213317963.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-04-14 at 13:49 -0400, David Miller wrote:

> Yep that would handle the l2tp cases, but vxlan needs something different
> since it goes through iptunnel_xmit().
> 
> So perhaps as a quick fix we can add an 'sk' arg to both
> ip_queue_xmit() and ip_local_out().

Right, I am working on this right now.


