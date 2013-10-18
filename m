Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751643Ab3JRHNV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 03:13:21 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51494 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3JRHNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 03:13:20 -0400
Date: Fri, 18 Oct 2013 03:13:17 -0400 (EDT)
Message-Id: <20131018.031317.1551678106943004158.davem@davemloft.net>
To: rusty@rustcorp.com.au
Cc: mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net V2 1/2] virtio-net: don't respond to cpu hotplug
 notifier if we're not ready
From: David Miller <davem@davemloft.net>
In-Reply-To: <87iowvje6t.fsf@rustcorp.com.au>
References: <87d2n3s89s.fsf@rustcorp.com.au>
	<20131017.234816.1960399038382112445.davem@davemloft.net>
	<87iowvje6t.fsf@rustcorp.com.au>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 18 Oct 2013 00:13:20 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rusty Russell <rusty@rustcorp.com.au>
Date: Fri, 18 Oct 2013 16:47:14 +1030

> Do you want awk script to turn the latter into the former?  Would that
> really help?

Rusty in the several years I've been operating this way, you're
the first person who seems to mind it.

To be honest I sometimes just silently deal with the stable CC:,
but it's much easier if things operate as they do now, and the
burdon is on the submitter instead of me.
