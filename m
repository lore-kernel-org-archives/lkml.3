Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857AbaJPUUP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Oct 2014 16:20:15 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:55131 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751875AbaJPUUN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Oct 2014 16:20:13 -0400
Date: Thu, 16 Oct 2014 23:20:11 +0300 (EEST)
From: Meelis Roos <mroos@linux.ee>
To: David Miller <davem@redhat.com>
cc: iamjoonsoo.kim@lge.com, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
In-Reply-To: <20141016.160742.1639247937393238792.davem@redhat.com>
Message-ID: <alpine.LRH.2.11.1410162319080.19924@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410150012001.11850@adalberg.ut.ee> <20141014.173246.921084057467310731.davem@davemloft.net> <alpine.LRH.2.11.1410160956090.13273@adalberg.ut.ee> <20141016.160742.1639247937393238792.davem@redhat.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just reproduced this on my Sun Blade 2500, so it can trigger on UltraSPARC-IIIi
> systems too.

I looked it up - V210 and V440 are also IIIi, not plain III. So I do not 
have information about real USIII, sorry for confusion.

-- 
Meelis Roos (mroos@linux.ee)
