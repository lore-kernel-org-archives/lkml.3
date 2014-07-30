Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755789AbaG3WgM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:36:12 -0400
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:39080 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751934AbaG3WgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:36:11 -0400
X-Greylist: delayed 1948 seconds by postgrey-1.27 at vger.kernel.org; Wed, 30 Jul 2014 18:36:11 EDT
Date: Thu, 31 Jul 2014 01:02:53 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@davemloft.net>
cc: aaro.koskinen@iki.fi, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, hughd@google.com,
        cat.schulze@alice-dsl.net
Subject: Re: sparc64 WARNING: at mm/mmap.c:2757 exit_mmap+0x13c/0x160()
In-Reply-To: <20140729.162635.638786990787878495.davem@davemloft.net>
Message-ID: <alpine.SOC.1.00.1407310101550.2065@math.ut.ee>
References: <20140414184353.GA5630@drone.musicnaut.iki.fi> <20140416.145822.1317931249717152474.davem@davemloft.net> <alpine.SOC.1.00.1404170119550.20193@math.ut.ee> <20140729.162635.638786990787878495.davem@davemloft.net>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Here is something I'd like you guys to test.

Very interesting.

[...]
> Could you guys please try this patch below?  Thanks.

  CC      arch/sparc/mm/init_64.o
arch/sparc/mm/init_64.c: In function 'update_mmu_cache_pmd':
arch/sparc/mm/init_64.c:2625:6: error: 'pte' may be used uninitialized in this function [-Werror=uninitialized]

gcc 4.6.4.

-- 
Meelis Roos (mroos@linux.ee)
