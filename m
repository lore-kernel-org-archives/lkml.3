Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752259AbaGVEiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 00:38:01 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:41311 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751930AbaGVEh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 00:37:59 -0400
Date: Mon, 21 Jul 2014 21:37:57 -0700 (PDT)
Message-Id: <20140721.213757.334607182319263871.davem@davemloft.net>
To: himangi774@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr, sam@ravnborg.org
Subject: Re: [PATCH] display7seg: Introduce the use of the managed version
 of kzalloc
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140526213207.GA1815@himangi-Dell>
References: <20140526213207.GA1815@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 21 Jul 2014 21:37:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Tue, 27 May 2014 03:02:07 +0530

> This patch moves data allocated using kzalloc to managed data allocated
> using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
> functions. The header file is added to make the devm function explicitly
> available.
> 
> The following Coccinelle semantic patch was used for making a part of
> the change:
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>
> Acked-by: Sam Ravnborg <sam@ravnborg.org>

Applied to sparc-next.
