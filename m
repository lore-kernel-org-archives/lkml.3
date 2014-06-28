Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752021AbaF1KMp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 06:12:45 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45796 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750923AbaF1KMn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 06:12:43 -0400
Date: Sat, 28 Jun 2014 12:12:40 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nick Warne <nick@linicks.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
Message-ID: <20140628101240.GA6357@pd.tnic>
References: <53AE9058.50902@linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53AE9058.50902@linicks.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 10:52:24AM +0100, Nick Warne wrote:
> Hi Everybody,
> 
> Today I was trying to build 3.15.2 on AMD64 from kernel 3.14.8 and get this:
> 
>   CC      fs/mbcache.o
> fs/mbcache.c: In function ‘__spin_lock_mb_cache_entry’:
> fs/mbcache.c:134: error: SSE register return with SSE disabled
> make[1]: *** [fs/mbcache.o] Error 1

I can't trigger that here.

Please send your .config. Also, before building, did you clean up your
source tree properly by saving the .config somewhere else and doing
"make mrproper"?

If not, do that too.

HTH.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
