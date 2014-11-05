Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588AbaKEUw6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 15:52:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:48035 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaKEUw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 15:52:57 -0500
Date: Wed, 05 Nov 2014 15:52:55 -0500 (EST)
Message-Id: <20141105.155255.85151784742273625.davem@davemloft.net>
To: linux@rasmusvillemoes.dk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] include/linux/socket.h: Fix comment
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415220267-20044-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1415220267-20044-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 05 Nov 2014 12:52:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Wed,  5 Nov 2014 21:44:27 +0100

> File descriptors are always closed on exit :-)
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Applied, thanks.
