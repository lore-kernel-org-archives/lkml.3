Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757232Ab3G3TzL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jul 2013 15:55:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40983 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab3G3TzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jul 2013 15:55:09 -0400
Date: Tue, 30 Jul 2013 12:55:06 -0700 (PDT)
Message-Id: <20130730.125506.1487990387098277825.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net V2 1/2] tuntap: do not zerocopy if iov needs more
 pages than MAX_SKB_FRAGS
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130730114113.GA22218@redhat.com>
References: <1374116116-43844-1-git-send-email-jasowang@redhat.com>
	<20130719050335.GA8537@redhat.com>
	<20130730114113.GA22218@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 30 Jul 2013 12:55:08 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Tue, 30 Jul 2013 14:41:13 +0300

> Was this patch dropped?

No, it's commit 885291761dba2bfe04df4c0f7bb75e4c920ab82e

> Any objections to merging it for 3.11 and stable?

No objections, queued up for -stable.
