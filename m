Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751822AbaIJDk0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 23:40:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35641 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750844AbaIJDkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 23:40:21 -0400
Date: Tue, 09 Sep 2014 20:40:20 -0700 (PDT)
Message-Id: <20140909.204020.352836914323089696.davem@davemloft.net>
To: yamada.m@jp.panasonic.com
Cc: linux-kbuild@vger.kernel.org, ben-linux@fluff.org, kgene.kim@samsung.com,
        linux@arm.linux.org.uk, mturquette@linaro.org,
        laurent.pinchart+renesas@ideasonboard.com, horms+renesas@verge.net.au,
        geert@linux-m68k.org, wsa@sang-engineering.com, takasi-y@ops.dti.ne.jp,
        ulrich.hecht@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/3] kbuild: remove unnecessary "obj- := dummy.o" trick
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410258381-7088-2-git-send-email-yamada.m@jp.panasonic.com>
References: <1410258381-7088-1-git-send-email-yamada.m@jp.panasonic.com>
	<1410258381-7088-2-git-send-email-yamada.m@jp.panasonic.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 20:40:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masahiro Yamada <yamada.m@jp.panasonic.com>
Date: Tue,  9 Sep 2014 19:26:19 +0900

> In these Makefiles, at least one of "obj-y" and "obj-" is non-empty,
> hence built-in.o is always created without such a trick.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>

For networking:

Acked-by: David S. Miller <davem@davemloft.net>
