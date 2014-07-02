Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbaGBTOe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:14:34 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41121 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaGBTOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:14:32 -0400
Date: Wed, 02 Jul 2014 12:14:29 -0700 (PDT)
Message-Id: <20140702.121429.1078505008114493555.davem@davemloft.net>
To: edward.allcutt@openmarket.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ipv4: icmp: Fix pMTU handling for rare case
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.DEB.2.10.1407020954250.5997@tabini.allcutt.me.uk>
References: <alpine.DEB.2.10.1407010937120.5997@tabini.allcutt.me.uk>
	<20140701.110510.2218293817137911715.davem@davemloft.net>
	<alpine.DEB.2.10.1407020954250.5997@tabini.allcutt.me.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 02 Jul 2014 12:14:32 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Edward Allcutt <edward.allcutt@openmarket.com>
Date: Wed, 2 Jul 2014 10:05:13 +0100 (BST)

> On Tue, 1 Jul 2014, David Miller wrote:
>> I still think the OpenBSD thing can't be intentional, and it's some
>> bug they probably want to fix and it should therefore be investigated.
> 
> Shout at me if this is getting too off-topic..

It's something you should tell the OpenBSD folks about, more importantly
than us :)
