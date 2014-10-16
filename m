Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752789AbaJPUID (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:08:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751637AbaJPUIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:08:00 -0400
Date: Thu, 16 Oct 2014 16:07:42 -0400 (EDT)
Message-Id: <20141016.160742.1639247937393238792.davem@redhat.com>
To: mroos@linux.ee
Cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
From: David Miller <davem@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1410160956090.13273@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410150012001.11850@adalberg.ut.ee>
	<20141014.173246.921084057467310731.davem@davemloft.net>
	<alpine.LRH.2.11.1410160956090.13273@adalberg.ut.ee>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Thu, 16 Oct 2014 10:02:57 +0300 (EEST)

> scripts/Makefile.build:352: recipe for target 'sound/modules.order' failed
> make[1]: *** [sound/modules.order] Bus error
> make[1]: *** Deleting file 'sound/modules.order'
> Makefile:929: recipe for target 'sound' failed

I just reproduced this on my Sun Blade 2500, so it can trigger on UltraSPARC-IIIi
systems too.
