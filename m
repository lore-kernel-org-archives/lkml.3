Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932362AbaDXRIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 13:08:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:60946 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695AbaDXRIM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 13:08:12 -0400
Date: Thu, 24 Apr 2014 13:08:10 -0400 (EDT)
Message-Id: <20140424.130810.1854514715764795522.davem@davemloft.net>
To: zlim.lnx@gmail.com
Cc: nico@fluxnic.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        joe@perches.com
Subject: Re: [PATCH] smc91x: improve definition of debug macros
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398222282-8926-1-git-send-email-zlim.lnx@gmail.com>
References: <1398222282-8926-1-git-send-email-zlim.lnx@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 24 Apr 2014 10:08:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zi Shen Lim <zlim.lnx@gmail.com>
Date: Tue, 22 Apr 2014 20:04:42 -0700

> Redefine some macros that were conditioned upon SMC_DEBUG level.
> 
> By allowing compiler to verify parameters used by these macros
> unconditionally, we can flag compilation failures.
> 
> Compiler will still optimize out the unused code path depending on
> SMC_DEBUG, so this is a net gain.
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> Signed-off-by: Zi Shen Lim <zlim.lnx@gmail.com>

Applied, thanks.
