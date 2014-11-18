Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932538AbaKRUz7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 15:55:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56847 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932509AbaKRUz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 15:55:57 -0500
Date: Tue, 18 Nov 2014 15:55:55 -0500 (EST)
Message-Id: <20141118.155555.1723816756575377497.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 net-next] dev_ioctl: use sizeof(x) instead of
 sizeof x
From: David Miller <davem@davemloft.net>
In-Reply-To: <1416259397-10954-1-git-send-email-fabf@skynet.be>
References: <1416259397-10954-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 18 Nov 2014 12:55:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Mon, 17 Nov 2014 22:23:17 +0100

> Also remove spaces after cast.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
