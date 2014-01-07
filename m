Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaAGC3p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 21:29:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36919 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaAGC3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 21:29:44 -0500
Date: Mon, 06 Jan 2014 21:29:40 -0500 (EST)
Message-Id: <20140106.212940.42449270782533770.davem@davemloft.net>
To: ethan.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
Subject: Re: [PATCH] sparc: replace __GFP_NOFAIL with GFP_ATOMIC in
 mdesc_kmalloc()
From: David Miller <davem@davemloft.net>
In-Reply-To: <CABawtvPt9V_2=KxOGetUCVeatJVcD-uJqs9c6cUzOc2uZCqpYg@mail.gmail.com>
References: <1386773661-921-1-git-send-email-ethan.kernel@gmail.com>
	<CABawtvPt9V_2=KxOGetUCVeatJVcD-uJqs9c6cUzOc2uZCqpYg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 06 Jan 2014 18:29:44 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ethan Zhao <ethan.kernel@gmail.com>
Date: Tue, 7 Jan 2014 10:21:51 +0800

> cc sparclinux@vger.kernel.org

Please make a fresh patch posting with sparclinux included so that
your patch gets properly queued up and tracked in patchwork:

http://patchwork.ozlabs.org/project/sparclinux/list/

Thanks.
