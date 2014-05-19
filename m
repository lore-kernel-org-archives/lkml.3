Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467AbaESBZZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 21:25:25 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44428 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaESBZY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 21:25:24 -0400
Date: Sun, 18 May 2014 21:25:22 -0400 (EDT)
Message-Id: <20140518.212522.350363042376906283.davem@davemloft.net>
To: manuel.schoelling@gmx.de
Cc: tedheadster@gmail.com, joe@perches.com, paul.gortmaker@windriver.com,
        jg1.han@samsung.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: 8390: use time_after() for time comparison
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400409948-29399-1-git-send-email-manuel.schoelling@gmx.de>
References: <1400409948-29399-1-git-send-email-manuel.schoelling@gmx.de>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 18:25:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manuel Schölling <manuel.schoelling@gmx.de>
Date: Sun, 18 May 2014 12:45:48 +0200

> To be future-proof and for better readability the time comparisons are modified
> to use time_after() instead of raw math.
> 
> Signed-off-by: Manuel Schölling <manuel.schoelling@gmx.de>

Applied.
