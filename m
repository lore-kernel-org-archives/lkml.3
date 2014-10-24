Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752929AbaJXEmD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 00:42:03 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:46392 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752065AbaJXEmB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 00:42:01 -0400
Date: Fri, 24 Oct 2014 00:41:59 -0400 (EDT)
Message-Id: <20141024.004159.1994894378428875914.davem@davemloft.net>
To: linux@rasmusvillemoes.dk
Cc: dave@thedillows.org, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: typhoon: Remove redundant casts
From: David Miller <davem@davemloft.net>
In-Reply-To: <1413903103-3047-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1413903103-3047-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Oct 2014 21:42:00 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Tue, 21 Oct 2014 16:51:43 +0200

> Both image_data and typhoon_fw->data are const u8*, so the cast to u8*
> is unnecessary and confusing.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Applied.
