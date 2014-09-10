Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751759AbaIJDkP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:40:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35635 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750981AbaIJDkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:40:11 -0400
Date: Tue, 09 Sep 2014 20:40:10 -0700 (PDT)
Message-Id: <20140909.204010.1603269511237977404.davem@davemloft.net>
To: dhowells@redhat.com
Cc: netdev@vger.kernel.org, linux-afs@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] RxRPC: Fix missing __user annotation
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140909141944.18112.74852.stgit@warthog.procyon.org.uk>
References: <20140909141944.18112.74852.stgit@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 20:40:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Tue, 09 Sep 2014 15:19:44 +0100

> Fix a missing __user annotation in a cast of a user space pointer (found by
> checker).
> 
> Signed-off-by: David Howells <dhowells@redhat.com>

Applied.
