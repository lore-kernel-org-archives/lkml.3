Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755265Ab3I2VbL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 17:31:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49283 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab3I2VbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 17:31:09 -0400
Date: Sun, 29 Sep 2013 17:31:06 -0400 (EDT)
Message-Id: <20130929.173106.475537080284868036.davem@davemloft.net>
To: baker.kernel@gmail.com
Cc: kuznet@ms2.inr.ac.ru, jmorris@namei.org, yoshfuji@linux-ipv6.org,
        kaber@trash.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 net-next] fib_trie: avoid a redundant bit judgement
 in inflate
From: David Miller <davem@davemloft.net>
In-Reply-To: <1380461518-10095-1-git-send-email-baker.kernel@gmail.com>
References: <1380461518-10095-1-git-send-email-baker.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sun, 29 Sep 2013 14:31:09 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Based upon how quickly you sent these two patches, the first of which
wouldn't even compile, I have zero confidence that you actually
booted and tested this patch at all.

I'm not applying this until you take the time to boot and test the
change in some way, and say explicitly in your commit message how
you tested it.
