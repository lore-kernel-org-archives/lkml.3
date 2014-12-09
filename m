Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841AbaLIVOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 16:14:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38806 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394AbaLIVOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 16:14:20 -0500
Date: Tue, 09 Dec 2014 16:14:18 -0500 (EST)
Message-Id: <20141209.161418.956404204470791145.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux@rasmusvillemoes.dk, joe@perches.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/20] chelsio: fix misspelling of current function in
 string
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417980062-25151-15-git-send-email-Julia.Lawall@lip6.fr>
References: <1417980062-25151-1-git-send-email-Julia.Lawall@lip6.fr>
	<1417980062-25151-15-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Dec 2014 13:14:20 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Sun,  7 Dec 2014 20:20:56 +0100

> Replace a misspelled function name by %s and then __func__.
> 
> This was done using Coccinelle, including the use of Levenshtein distance,
> as proposed by Rasmus Villemoes.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Applied.
