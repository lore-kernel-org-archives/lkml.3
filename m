Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707AbaFIGgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 02:36:43 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:41754 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbaFIGgm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 02:36:42 -0400
Date: Mon, 9 Jun 2014 09:36:33 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
In-Reply-To: <20140524.170834.1561021346958622230.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1406090931470.5548@math.ut.ee>
References: <20140425200908.GG575@drone.musicnaut.iki.fi> <20140425.161753.153968588224593753.davem@davemloft.net> <alpine.SOC.1.00.1405242301090.18040@math.ut.ee> <20140524.170834.1561021346958622230.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > This is todays fresh git with 3.15.0-rc6-00190-g1ee1cea on V210, THP 
> > enabled & always on. Got this and a segfault on apt-spawned xz.
> 
> Thanks a lot for the report.
> 
> I've been bogged down with other things but I will come back to
> this stuff soon.

Just to document a strangeness that does not seem to fit the pattern of 
UltraSparc III era split: 

V210 with USIII family CPUs is still problematic (can not survive 
repetituos local git clone, hangs (watchdog detects hang) with 
filesystem corruption. This still holds for 3.15 release.

On the other hand, E420R with 4 USII CPUs does not hang and works 100% 
stable with git clones etc. Very similar E220R with different config 
hangs on that load.

Maybe related to some other options in kernel configs - each config is 
unique and they vary intentionally.

-- 
Meelis Roos (mroos@linux.ee)
