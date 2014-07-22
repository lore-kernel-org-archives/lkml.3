Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548AbaGVEiX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:38:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41340 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751466AbaGVEiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:38:21 -0400
Date: Mon, 21 Jul 2014 21:38:18 -0700 (PDT)
Message-Id: <20140721.213818.1578856121778935701.davem@davemloft.net>
To: linux@rasmusvillemoes.dk
Cc: paul.gortmaker@windriver.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/sbus/char: Micro-optimization in display7seg.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1403181112-12018-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1403181112-12018-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Jul 2014 21:38:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Thu, 19 Jun 2014 14:31:52 +0200

> Flipping a bit doesn't need four lines of code; and gcc seems to
> actually generate two branches.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Applied to sparc-next
