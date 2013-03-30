Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756588Ab3C3VMu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Mar 2013 17:12:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39843 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3C3VMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Mar 2013 17:12:48 -0400
Date: Sat, 30 Mar 2013 17:12:46 -0400 (EDT)
Message-Id: <20130330.171246.1914117581717713508.davem@davemloft.net>
To: artem.savkov@gmail.com
Cc: johannes.berg@intel.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/wireless/sme: sched_scan_mtx lock in
 cfg80211_conn_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1364664014-12304-1-git-send-email-artem.savkov@gmail.com>
References: <1364664014-12304-1-git-send-email-artem.savkov@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 30 Mar 2013 14:12:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Savkov <artem.savkov@gmail.com>
Date: Sat, 30 Mar 2013 21:20:14 +0400

> Introduced in f9f475292dbb0e7035fb6661d1524761ea0888d9

When referencing commits, always provide the commit message header
line, in parenthesis and double quotes, so that it is unambiguous.

Otherwise, when changes are backported into -stable trees, the commit
ID changes and the commit in question can no longer be indentified
easily for the reader.
