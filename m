Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758983AbaGYGcJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 02:32:09 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58786 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186AbaGYGcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 02:32:07 -0400
Date: Thu, 24 Jul 2014 23:32:05 -0700 (PDT)
Message-Id: <20140724.233205.2150921422705096729.davem@davemloft.net>
To: himangi774@gmail.com
Cc: isdn@linux-pingi.de, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        julia.lawall@lip6.fr
Subject: Re: [PATCH] isdn: use constants instead of magicnumbers
From: David Miller <davem@davemloft.net>
In-Reply-To: <20140723211638.GA4283@himangi-Dell>
References: <20140723211638.GA4283@himangi-Dell>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Jul 2014 23:32:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Himangi Saraogi <himangi774@gmail.com>
Date: Thu, 24 Jul 2014 02:46:38 +0530

> This patch changes instances of magic numbers like 4 and 8 to equivalent
> constants.
> 
> The Coccinelle semantic patch used for making the change is as follows:
 ...
> Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
> Acked-by: Julia Lawall <julia.lawall@lip6.fr>

Applied, thank you.
