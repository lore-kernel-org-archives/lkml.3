Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756593Ab3AUUQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 15:16:52 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51197 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab3AUUQu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 15:16:50 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH 02/15] ARM: mvebu: build coherency_ll.S for arch=armv7-a
Date: Mon, 21 Jan 2013 20:16:13 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-3-git-send-email-arnd@arndb.de> <20130121190302.GN22517@atomide.com>
In-Reply-To: <20130121190302.GN22517@atomide.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212016.13727.arnd@arndb.de>
X-Provags-ID: V02:K0:m53rEFMsnSrQbqlL0iqVqG8H9zvbdEz8TxrZdLt5niS
 5paTLdxR8bPTGtYbukhLbTE+vwIEsuViF2o0NKjG9ECEEeWwEF
 0CCPGyVRIspze6xcpLuQImr7wzjJICUE+iG1Q9N80y6rWJ2ogu
 ylOVlOzhCU0Lw/x7GnI6zTlc5vhf72OrTmbveUfbWeXkDPORDo
 7ju7hdCPCqahPxL80I/PBv777zJpwzMXxBLXog6NnVhizfatT7
 wzDRFDVv5VUePOjVE2kbvRgbCSo7NgRYzFbLTmm/d4Qq4spfZS
 J8+Y9QAYe9MgZH4UU2zEOyl/+SS8CjHh7D+kXbJzBIJIsfmFnS
 7XEQKNPRYzPKLOOAK4p8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Tony Lindgren wrote:
> > 
> > arch/arm/mach-mvebu/coherency_ll.S: Assembler messages:
> > arch/arm/mach-mvebu/coherency_ll.S:45: Error: selected processor does not support ARM mode `dsb'
> 
> This should be already fixed by 72533b (arm: mvebu: Fix compile for
> multiplatform when ARMv6 is selected) in arm-soc fixes branch.
> 

Ok, silly me, I forgot to check my own tree :)

Thanks for looking into it!

	Arnd
