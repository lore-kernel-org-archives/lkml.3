Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaDYTnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 15:43:43 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46093 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbaDYTnl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 15:43:41 -0400
Date: Fri, 25 Apr 2014 15:43:37 -0400 (EDT)
Message-Id: <20140425.154337.1159533755150765063.davem@davemloft.net>
To: sparclinux@vger.kernel.org
CC: mroos@linux.ee, aaro.koskinen@iki.fi, hughd@google.com,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Fix several sparc64 THP bugs.
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 25 Apr 2014 12:43:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Meelis and Aaro, I've found and fixed several THP bugs for sparc64
over the last week or so.

I cannot %100 account for the exit_mmap() WARN_ON that you two have
been able to trigger, however I'd like you both to test the changes
nonetheless.

They are against 3.15 but they should apply cleanly all the way back
to 3.13

Thanks in advance for testing.
