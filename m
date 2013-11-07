Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753373Ab3KGHO7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:14:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47159 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab3KGHOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:14:52 -0500
Date: Thu, 07 Nov 2013 02:14:48 -0500 (EST)
Message-Id: <20131107.021448.1956863550827879584.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next trivial] udp: Remove unnecessary semicolon
 from do{}while (0) macro
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383689627.28624.3.camel@joe-AO722>
References: <1383689627.28624.3.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 06 Nov 2013 23:14:52 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 05 Nov 2013 14:13:47 -0800

> Just an unnecessary semicolon that should be removed...
> 
> Whitespace neatening of macro too.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Applied.
