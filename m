Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754344AbaIOQt7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 12:49:59 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33987 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753027AbaIOQt5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 12:49:57 -0400
Date: Mon, 15 Sep 2014 12:49:55 -0400 (EDT)
Message-Id: <20140915.124955.2290311216753561340.davem@davemloft.net>
To: fabf@skynet.be
Cc: linux-kernel@vger.kernel.org, rmody@brocade.com, netdev@vger.kernel.org
Subject: Re: [PATCH 2/4 linux-next] bna: use container_of to resolve
 bufdesc_ex from bufdesc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410640709-18295-3-git-send-email-fabf@skynet.be>
References: <1410640709-18295-1-git-send-email-fabf@skynet.be>
	<1410640709-18295-3-git-send-email-fabf@skynet.be>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 15 Sep 2014 09:49:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fabian Frederick <fabf@skynet.be>
Date: Sat, 13 Sep 2014 22:38:27 +0200

> Use container_of instead of casting first structure member.
> 
> Compiled but untested.
> 
> Signed-off-by: Fabian Frederick <fabf@skynet.be>

Applied.
