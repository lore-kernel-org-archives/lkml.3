Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932463AbaIDDhO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 23:37:14 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51859 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163AbaIDDhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 23:37:12 -0400
Date: Wed, 03 Sep 2014 20:38:14 -0700 (PDT)
Message-Id: <20140903.203814.642492840095995090.davem@davemloft.net>
To: standby24x7@gmail.com
Cc: linux-kernel@vger.kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        rdunlap@infradead.org, linux-doc@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH] net: treewide: Fix typo found in DocBook/networking.xml
From: David Miller <davem@davemloft.net>
In-Reply-To: <1409716755-1994-1-git-send-email-standby24x7@gmail.com>
References: <1409716755-1994-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 03 Sep 2014 20:37:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>
Date: Wed,  3 Sep 2014 12:59:15 +0900

>   * When used in combination with the softirq_exit tracepoint
> - * we can determine the softirq handler runtine.
> + * we can determine the softirq handler runtime.
>   */

The author of this comment meant to say "routine" not "runtime"
