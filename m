Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090AbaISVJP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 17:09:15 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:59298 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757728AbaISVJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 17:09:14 -0400
Date: Fri, 19 Sep 2014 17:09:12 -0400 (EDT)
Message-Id: <20140919.170912.2121690640992286584.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 1/1 RESEND] lib: rhashtable: remove second linux/log2.h
 inclusion
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410980839-5809-1-git-send-email-fabf@skynet.be>
References: <1410980839-5809-1-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 19 Sep 2014 14:09:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Wed, 17 Sep 2014 21:07:19 +0200

> linux/log2.h was included twice.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied, thanks.
