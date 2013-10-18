Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755016Ab3JRDsT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 23:48:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:50043 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753844Ab3JRDsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 23:48:18 -0400
Date: Thu, 17 Oct 2013 23:48:16 -0400 (EDT)
Message-Id: <20131017.234816.1960399038382112445.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net V2 1/2] virtio-net: don't respond to cpu hotplug
 notifier if we're not ready
From: David Miller <davem@davemloft.net>
In-Reply-To: <87d2n3s89s.fsf@rustcorp.com.au>
References: <8738o0aj9u.fsf@rustcorp.com.au>
	<20131017050710.GA12141@redhat.com>
	<87d2n3s89s.fsf@rustcorp.com.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 17 Oct 2013 20:48:18 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 18 Oct 2013 11:30:15 +1030

> Asking people to express 'CC: stable' in words is error-prone; if Dave
> wants to filter it, he's quite capable.

Filtering it one time is one thing.

Potentially acting on that filter 100 or so times a day...

That's completely another.
