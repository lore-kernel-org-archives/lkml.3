Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161006AbaDPNAJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:00:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45143 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaDPNAE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:00:04 -0400
Date: Wed, 16 Apr 2014 09:00:02 -0400 (EDT)
Message-Id: <20140416.090002.2186526865564557549.davem@davemloft.net>
To: eric.dumazet@gmail.com
Cc: neilb@suse.de, linux-mm@kvack.org, linux-nfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, netdev@vger.kernel.org
Subject: Re: [PATCH 10/19] NET: set PF_FSTRANS while holding sk_lock
From: David Miller <davem@davemloft.net>
In-Reply-To: <1397625226.4222.113.camel@edumazet-glaptop2.roam.corp.google.com>
References: <20140416033623.10604.69237.stgit@notabene.brown>
	<20140416040336.10604.96000.stgit@notabene.brown>
	<1397625226.4222.113.camel@edumazet-glaptop2.roam.corp.google.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 16 Apr 2014 06:00:04 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Eric Dumazet <eric.dumazet@gmail.com>
Date: Tue, 15 Apr 2014 22:13:46 -0700

> For applications handling millions of sockets, this makes a difference.

Indeed, this really is not acceptable.
