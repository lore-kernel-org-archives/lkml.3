Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733AbaF1MX1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 08:23:27 -0400
Received: from mail.skyhub.de ([78.46.96.112]:60726 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031AbaF1MX0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 08:23:26 -0400
Date: Sat, 28 Jun 2014 14:23:22 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nick Warne <nick@linicks.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 3.15.2 build error on AMD64
Message-ID: <20140628122322.GC4373@pd.tnic>
References: <53AE9058.50902@linicks.net>
 <20140628101240.GA6357@pd.tnic>
 <53AE9863.6050102@linicks.net>
 <53AE9F0B.1080207@linicks.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <53AE9F0B.1080207@linicks.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 11:55:07AM +0100, Nick Warne wrote:
> Whoops - that is WRONG (too many ssh terminals)
> 
> gcc version 4.2.4

That's some old compiler. Anyway, I can't trigger it here with gcc 4.6
and 4.9.

Can you do

$ make clean
$ make V=1 fs/mbcache.i >>w.log 2>&1
$ make V=1 fs/mbcache.s >>w.log 2>&1

and zip and send me fs/mbcache.i, fs/mbcache.s and w.log.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
