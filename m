Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab3ANXaP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:30:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35736 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756959Ab3ANXaN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:30:13 -0500
Date: Mon, 14 Jan 2013 18:30:09 -0500 (EST)
Message-Id: <20130114.183009.826634301471863252.davem@davemloft.net>
To: dinggnu@gmail.com
Cc: chas@cmf.nrl.navy.mil, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] atm: fore200e.c: fix uninitialized variable
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358189864-28735-1-git-send-email-dinggnu@gmail.com>
References: <1358189864-28735-1-git-send-email-dinggnu@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Ding <dinggnu@gmail.com>
Date: Mon, 14 Jan 2013 18:57:43 +0000

> the variable err is uninitialized if all the macros in the function are
> disabled.

Which is never possible because of the Kconfig dependencies.

This is what happens when you focus to narrowly on a piece of
code, you take no context whatsoever into consideration.
