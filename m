Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab3KPBma (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 20:42:30 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60955 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751192Ab3KPBmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 20:42:25 -0500
Date: Fri, 15 Nov 2013 20:42:24 -0500 (EST)
Message-Id: <20131115.204224.1984987969340090384.davem@davemloft.net>
To: petkan@nucleusys.com
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: Update Pegasus and RTL8150 driver
 repositories;
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131115102344.GA8544@bender.nucleusys.com>
References: <20131115102344.GA8544@bender.nucleusys.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Fri, 15 Nov 2013 17:42:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Petko Manolov <petkan@nucleusys.com>
Date: Fri, 15 Nov 2013 12:23:44 +0200

> From: Petko Manolov <petkan@nucleusys.com>
> Date: Fri, 15 Nov 2013 11:51:54 +0200
> Subject: [PATCH] Update Pegasus and RTL8150 repositories;

Do not include this metadata in your patch postings, it duplicates
the commit header line when people try to apply it using "git am"

> Update Pegasus and RTL8150 driver repositories;
> 
> The diff is against latest 'net' repository;
> 
> Signed-off-by: Petko Manolov <petkan@nucleusys.com>

Please submit networking patches to netdev@vger.kernel.org in the
future, I happened to catch this and applied it this time.

Thanks.
