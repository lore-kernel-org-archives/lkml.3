Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752693Ab3FEAn0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 20:43:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60783 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051Ab3FEAnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 20:43:24 -0400
Date: Tue, 04 Jun 2013 17:43:23 -0700 (PDT)
Message-Id: <20130604.174323.350497684225826523.davem@davemloft.net>
To: andy.shevchenko@gmail.com
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: core: move mac_pton() to lib/net_utils.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1370364386-5034-1-git-send-email-andy.shevchenko@gmail.com>
References: <1370364386-5034-1-git-send-email-andy.shevchenko@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Tue,  4 Jun 2013 19:46:26 +0300

> Since we have at least one user of this function outside of CONFIG_NET
> scope, we have to provide this function independently. The proposed
> solution is to move it under lib/net_utils.c with corresponding
> configuration variable and select wherever it is needed.
> 
> Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
> Reported-by: Arnd Bergmann <arnd@arndb.de>

I do not see a mac_pton() usage under drivers/misc in any of my trees,
so I really am not the person to apply this.
