Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756608Ab3AUU3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:29:20 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:42535 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab3AUU3S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:29:18 -0500
Date: Mon, 21 Jan 2013 15:29:13 -0500 (EST)
Message-Id: <20130121.152913.1377695352860141642.davem@davemloft.net>
To: thierry.reding@avionic-design.de
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        dmitry.torokhov@gmail.com, arnd@arndb.de, w.sang@pengutronix.de,
        netdev@vger.kernel.org
Subject: Re: [PATCH 20/33] net: Convert to devm_ioremap_resource()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358762966-20791-21-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
	<1358762966-20791-21-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <thierry.reding@avionic-design.de>
Date: Mon, 21 Jan 2013 11:09:13 +0100

> Convert all uses of devm_request_and_ioremap() to the newly introduced
> devm_ioremap_resource() which provides more consistent error handling.
> 
> devm_ioremap_resource() provides its own error messages so all explicit
> error messages can be removed from the failure code paths.
> 
> Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>

This won't compile if I apply it.

You really have to be clear when you submit patches like this.

Since you only CC:'d the networking developers for this one
patch, there is _ZERO_ context for us to work with to understand
what's going on.

You have to also CC: us on the other relevant changes and your
"[PATCH 00/33]" posting that explains what is happening.
