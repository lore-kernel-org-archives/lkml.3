Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752471AbaESAvt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2014 20:51:49 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44168 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752152AbaESAvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2014 20:51:47 -0400
Date: Sun, 18 May 2014 20:51:35 -0400 (EDT)
Message-Id: <20140518.205135.2035618521487962929.davem@davemloft.net>
To: joe@perches.com
Cc: ariele@broadcom.com, dmitry@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: Convert return 0 to return rc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400223103.30884.5.camel@joe-AO725>
References: <1400223103.30884.5.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sun, 18 May 2014 17:51:47 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 15 May 2014 23:51:43 -0700

> These "return 0;" uses seem wrong as there are
> rc variables where error return values are set
> but unused.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied, thanks Joe.
