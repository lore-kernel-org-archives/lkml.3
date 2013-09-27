Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab3I0OkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 10:40:15 -0400
Received: from void.printf.net ([89.145.121.20]:42613 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734Ab3I0OkM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:40:12 -0400
From: Chris Ball <cjb@laptop.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dong Aisheng <b29396@freescale.com>
Subject: Re: linux-next: build failure after merge of the final tree
References: <20130927183246.13094a90de1676232e17d30e@canb.auug.org.au>
Date: Fri, 27 Sep 2013 15:40:10 +0100
In-Reply-To: <20130927183246.13094a90de1676232e17d30e@canb.auug.org.au>
	(Stephen Rothwell's message of "Fri, 27 Sep 2013 18:32:46 +1000")
Message-ID: <86a9iycoqd.fsf@void.printf.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Fri, Sep 27 2013, Stephen Rothwell wrote:
> drivers/mmc/host/sdhci-of-esdhc.c: In function 'esdhc_of_set_clock':
> drivers/mmc/host/sdhci-of-esdhc.c:230:10: error: 'host_clock' undeclared (first use in this function)
>    clock, host_clock / pre_div / div);

Sorry about that.  I've pushed the proper fix out to mmc-next now,
so you can drop your temporary fix.

Thanks,

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
