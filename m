Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755640Ab3AUSTR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 13:19:17 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:40639 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab3AUSTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 13:19:14 -0500
Date: Mon, 21 Jan 2013 13:19:12 -0500 (EST)
Message-Id: <20130121.131912.602907116084738120.davem@davemloft.net>
To: Julia.Lawall@lip6.fr
Cc: herbert@gondor.hengli.com.au, kernel-janitors@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/15] drivers/crypto/atmel-aes.c: adjust duplicate test
From: David Miller <davem@davemloft.net>
In-Reply-To: <1358773378-4700-8-git-send-email-Julia.Lawall@lip6.fr>
References: <1358773378-4700-1-git-send-email-Julia.Lawall@lip6.fr>
	<1358773378-4700-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>
Date: Mon, 21 Jan 2013 14:02:51 +0100

> From: Julia Lawall <Julia.Lawall@lip6.fr>
> 
> Delete successive tests to the same location.  The code tested the result
> of a previous allocation, that itself was already tested.  It is changed to
> test the result of the most recent allocation.
> 
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)
 ...
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

Acked-by: David S. Miller <davem@davemloft.net>
