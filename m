Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757745Ab3BZWhF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 17:37:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:43468 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753053Ab3BZWhD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 17:37:03 -0500
Date: Tue, 26 Feb 2013 17:37:00 -0500 (EST)
Message-Id: <20130226.173700.882998504986475149.davem@davemloft.net>
To: paolo.valente@unimore.it
Cc: jhs@mojatatu.com, shemminger@vyatta.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, fchecconi@gmail.com, rizzo@iet.unipi.it
Subject: Re: [PATCH BUGFIX] pkt_sched: fix little service anomalies and
 possible crashes of qfq+
From: David Miller <davem@davemloft.net>
In-Reply-To: <1361898166-18295-1-git-send-email-paolo.valente@unimore.it>
References: <20121226.151355.2215825989495032073.davem@davemloft.net>
	<1361898166-18295-1-git-send-email-paolo.valente@unimore.it>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 26 Feb 2013 14:37:07 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paolo valente <paolo.valente@unimore.it>
Date: Tue, 26 Feb 2013 18:02:46 +0100

> The portions of the code interested by each fix are small and do not
> overlap with each other, so I decided to provide just one patch
> (I hope that this was the right choice).

Please split this up into 6 patches, each with an appropriately
verbose analysis and explanation of each bug being fixed, thanks.

