Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753447AbbANVex (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 16:34:53 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:45575 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937AbbANVev (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 16:34:51 -0500
Date: Wed, 14 Jan 2015 16:34:49 -0500 (EST)
Message-Id: <20150114.163449.1861047394880254499.davem@davemloft.net>
To: bpoirier@suse.de
Cc: nikolay@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] netdevice: Add missing parentheses in macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <1421221955-9505-1-git-send-email-bpoirier@suse.de>
References: <1421221955-9505-1-git-send-email-bpoirier@suse.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 14 Jan 2015 13:34:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Benjamin Poirier <bpoirier@suse.de>
Date: Wed, 14 Jan 2015 16:52:35 +0900

> For example, one could conceivably call
> 	for_each_netdev_in_bond_rcu(condition ? bond1 : bond2, slave)
> and get an unexpected result.
> 
> Signed-off-by: Benjamin Poirier <bpoirier@suse.de>

Applied.
