Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaKUT6i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Nov 2014 14:58:38 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38198 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750918AbaKUT6g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Nov 2014 14:58:36 -0500
Date: Fri, 21 Nov 2014 14:58:34 -0500 (EST)
Message-Id: <20141121.145834.740588751080331229.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: amirv@mellanox.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: mlx4: don't duplicate kvfree()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141120081538.GJ7996@ZenIV.linux.org.uk>
References: <20141120081538.GJ7996@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Nov 2014 11:58:36 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Thu, 20 Nov 2014 08:15:38 +0000

> Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>

Applied.
