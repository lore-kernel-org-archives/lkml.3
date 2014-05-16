Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755468AbaEPUtv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 16:49:51 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49218 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859AbaEPUtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 16:49:50 -0400
Date: Fri, 16 May 2014 16:49:48 -0400 (EDT)
Message-Id: <20140516.164948.2294567280337873976.davem@davemloft.net>
To: joe@perches.com
Cc: Dmitry.Kravkov@qlogic.com, julia.lawall@lip6.fr, ariel.elior@qlogic.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] bnx2x: Convert return 0 to return rc
From: David Miller <davem@davemloft.net>
In-Reply-To: <1400271144.12373.21.camel@joe-AO725>
References: <1400223103.30884.5.camel@joe-AO725>
	<87B4DDAD5EAFA041BDC28F314593782D0172ECD7@avmb3.qlogic.org>
	<1400271144.12373.21.camel@joe-AO725>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 16 May 2014 13:49:49 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Fri, 16 May 2014 13:12:24 -0700

> Couple things actually:
> o Could you please update the MAINTAINER entry for
>   BNX2X?  Ariel Elior's email address is still listed
>   as @broadcom and that seems to bounce.

Let's please give the Broadcom folks a reasonable opportunity to update
the MAINTAINERS entry, thanks.
