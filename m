Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751064AbaI3U7z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 16:59:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49819 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaI3U7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 16:59:54 -0400
Date: Tue, 30 Sep 2014 16:59:51 -0400 (EDT)
Message-Id: <20140930.165951.1877491408006986300.davem@davemloft.net>
To: linux@roeck-us.net
Cc: ralf@linux-mips.org, linux-mips@linux-mips.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sfr@canb.auug.org.au
Subject: Re: [PATCH] next: mips: bpf: Fix build failure
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412095140-10953-1-git-send-email-linux@roeck-us.net>
References: <1412095140-10953-1-git-send-email-linux@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Sep 2014 13:59:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Tue, 30 Sep 2014 09:39:00 -0700

> Fix:
> 
> arch/mips/net/bpf_jit.c: In function 'build_body':
> arch/mips/net/bpf_jit.c:762:6: error: unused variable 'tmp'
> cc1: all warnings being treated as errors
> make[2]: *** [arch/mips/net/bpf_jit.o] Error 1
> 
> Seen when building mips:allmodconfig in -next since next-20140924.
> 
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>

Applied, thank you.
