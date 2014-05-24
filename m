Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751392AbaEXVIh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 May 2014 17:08:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:38793 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751238AbaEXVIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 May 2014 17:08:36 -0400
Date: Sat, 24 May 2014 17:08:34 -0400 (EDT)
Message-Id: <20140524.170834.1561021346958622230.davem@davemloft.net>
To: mroos@linux.ee
Cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1405242301090.18040@math.ut.ee>
References: <20140425200908.GG575@drone.musicnaut.iki.fi>
	<20140425.161753.153968588224593753.davem@davemloft.net>
	<alpine.SOC.1.00.1405242301090.18040@math.ut.ee>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 24 May 2014 14:08:36 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: mroos@linux.ee
Date: Sat, 24 May 2014 23:02:28 +0300 (EEST)

> This is todays fresh git with 3.15.0-rc6-00190-g1ee1cea on V210, THP 
> enabled & always on. Got this and a segfault on apt-spawned xz.

Thanks a lot for the report.

I've been bogged down with other things but I will come back to
this stuff soon.
