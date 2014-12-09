Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752986AbaLIVOn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:14:43 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38823 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751792AbaLIVOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:14:41 -0500
Date: Tue, 09 Dec 2014 16:14:38 -0500 (EST)
Message-Id: <20141209.161438.1929426728064530302.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: isdn@linux-pingi.de, kernel-janitors@vger.kernel.org,
        linux@rasmusvillemoes.dk, joe@perches.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/20] isdn: fix misspelling of current function in
 string
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417980062-25151-6-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
	<1417980062-25151-6-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 13:14:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sun,  7 Dec 2014 20:20:47 +0100

> Replace a misspelled function name by %s and then __func__.
> 
> In the first case, the print is just dropped, because kmalloc itself does
> enough error reporting.
> 
> This was done using Coccinelle, including the use of Levenshtein distance,
> as proposed by Rasmus Villemoes.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
