Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756174AbaCEBHL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 20:07:11 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:39403 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753625AbaCEBHJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 20:07:09 -0500
Date: Tue, 04 Mar 2014 20:07:05 -0500 (EST)
Message-Id: <20140304.200705.2133440563547580847.davem@davemloft.net>
To: zoltan.kiss@citrix.com
Cc: ian.campbell@citrix.com, wei.liu2@citrix.com,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jonathan.davies@citrix.com
Subject: Re: [PATCH net-next v6 9/9] xen-netback: Aggregate TX unmap
 operations
From: David Miller <davem@davemloft.net>
In-Reply-To: <531673BD.3070309@citrix.com>
References: <1393972341-21135-1-git-send-email-zoltan.kiss@citrix.com>
	<1393972341-21135-11-git-send-email-zoltan.kiss@citrix.com>
	<531673BD.3070309@citrix.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 04 Mar 2014 17:07:09 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zoltan Kiss <zoltan.kiss@citrix.com>
Date: Wed, 5 Mar 2014 00:45:49 +0000

> Despite all my efforts to do renumbering right, this subject still
> shows 9/9 instead of 10/10.

No worries.
