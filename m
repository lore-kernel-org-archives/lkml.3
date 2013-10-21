Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753685Ab3JUWrT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Oct 2013 18:47:19 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44320 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753634Ab3JUWrQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Oct 2013 18:47:16 -0400
Date: Mon, 21 Oct 2013 18:47:14 -0400 (EDT)
Message-Id: <20131021.184714.1113853778832206143.davem@davemloft.net>
To: michael.opdenacker@free-electrons.com
Cc: dm@chelsio.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgxb4: remove duplicate include in cxgb4.h
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382245801-19192-1-git-send-email-michael.opdenacker@free-electrons.com>
References: <1382245801-19192-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 21 Oct 2013 15:47:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Date: Sun, 20 Oct 2013 07:10:01 +0200

> Reported by "make includecheck"
> 
> Tested that C sources including this file still compile well on x86
> 
> Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>

Applied.
