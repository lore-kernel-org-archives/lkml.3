Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966072AbaLLUbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 15:31:32 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38231 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932702AbaLLUb3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 15:31:29 -0500
Date: Fri, 12 Dec 2014 15:31:27 -0500 (EST)
Message-Id: <20141212.153127.41600648682351296.davem@davemloft.net>
To: linux@rasmusvillemoes.dk
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers: ide: Fix mostly harmless off-by-one hardcoded
 value
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417125449-6007-1-git-send-email-linux@rasmusvillemoes.dk>
References: <1417125449-6007-1-git-send-email-linux@rasmusvillemoes.dk>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Dec 2014 12:31:29 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Date: Thu, 27 Nov 2014 22:57:29 +0100

> The string "IOMEGA Clik!" has length 12, not 11. Using strstarts
> avoids the error-prone hardcoding of the prefix length. For
> consistency, also change the occurence just above.
> 
> Signed-off-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>

Applied.
