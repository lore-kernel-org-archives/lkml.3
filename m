Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab3ETGzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 02:55:18 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54296 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753399Ab3ETGzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 02:55:16 -0400
Date: Sun, 19 May 2013 23:55:15 -0700 (PDT)
Message-Id: <20130519.235515.780417340578906662.davem@davemloft.net>
To: dborkman@redhat.com
Cc: eric.dumazet@gmail.com, netdev@vger.kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] x86: bpf_jit_comp: secure bpf jit against
 spraying attacks
From: David Miller <davem@davemloft.net>
In-Reply-To: <519905B6.3080101@redhat.com>
References: <1368844623.3301.142.camel@edumazet-glaptop>
	<519905B6.3080101@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 19 May 2013 23:55:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Daniel Borkmann <dborkman@redhat.com>
Date: Sun, 19 May 2013 19:02:46 +0200

> Probably other archs could later on follow-up with setting to
> read-only, too.

Only s390 and x86 support this facility.
