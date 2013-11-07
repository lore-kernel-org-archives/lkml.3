Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754150Ab3KGHP0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 02:15:26 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:47166 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab3KGHPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 02:15:05 -0500
Date: Thu, 07 Nov 2013 02:15:04 -0500 (EST)
Message-Id: <20131107.021504.523179934067535255.davem@davemloft.net>
To: joe@perches.com
Cc: netdev@vger.kernel.org, steve.glendinning@shawell.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smsc9420: Use netif_<level>
From: David Miller <davem@davemloft.net>
In-Reply-To: <1383676461.4387.28.camel@joe-AO722>
References: <1383676461.4387.28.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 06 Nov 2013 23:15:05 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Tue, 05 Nov 2013 10:34:21 -0800

> Use a more standard logging style.
> 
> Convert smsc_<level> macros to use netif_<level>.
> Remove unused #define PFX
> Add pr_fmt and neaten pr_<level> uses.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Also applied, thanks Joe.
