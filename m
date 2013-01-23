Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab3AWFCf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 00:02:35 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63725 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab3AWFCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 00:02:34 -0500
Message-ID: <1358917340.5752.57.camel@marge.simpson.net>
Subject: Re: [RFC PATCH 0/2] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <bitbucket@online.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@redhat.com, peterz@infradead.org,
        mingo@kernel.org, a.p.zijlstra@chello.nl
Date: Wed, 23 Jan 2013 06:02:20 +0100
In-Reply-To: <50FF52A2.9010604@linux.vnet.ibm.com>
References: <1356588535-23251-1-git-send-email-wangyun@linux.vnet.ibm.com>
	 <50ED384C.1030301@linux.vnet.ibm.com>
	 <1357977704.6796.47.camel@marge.simpson.net>
	 <1357985943.6796.55.camel@marge.simpson.net>
	 <1358155290.5631.19.camel@marge.simpson.net>
	 <50F79256.1010900@linux.vnet.ibm.com>
	 <1358654997.5743.17.camel@marge.simpson.net>
	 <50FCACE3.5000706@linux.vnet.ibm.com>
	 <1358743128.4994.33.camel@marge.simpson.net>
	 <50FCCCF5.30504@linux.vnet.ibm.com>
	 <1358750523.4994.55.camel@marge.simpson.net>
	 <1358752180.4994.65.camel@marge.simpson.net>
	 <50FCF212.3010504@linux.vnet.ibm.com>
	 <1358759355.4994.108.camel@marge.simpson.net>
	 <50FD08E1.8000302@linux.vnet.ibm.com>
	 <1358761496.4994.118.camel@marge.simpson.net>
	 <50FE0ADC.6060701@linux.vnet.ibm.com>
	 <1358841795.5782.255.camel@marge.simpson.net>
	 <50FE5433.1070801@linux.vnet.ibm.com>
	 <1358854481.5782.405.camel@marge.simpson.net>
	 <50FF52A2.9010604@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:KBO5Aew954F8XWuHaju3PDzexDqQF7nrhrrzOej9rGj
 K4Vd5K8WxwhZBpg7Y9oo1SMQi75KZAA6zSKJkBiQJvcLAdJxaM
 ZZAv0f7g788LFUZ0W65usDL9bZJwPzdKApRinAvjguUgZy0Bup
 6jiHBEXvSHCoqNgAR64sjH16O8Dm43ZrBG08V3Ymh/HYyxnW6q
 5FdrWnngtotnfZsqt0yXLynPO9piWAaQXx4B6DMGZHdiMi2Lh+
 B7z1sqX+cGwvAP+sD3FLnwYfgAx6N1aDHURvyQR3UVHhrDy0+8
 qsoMd0PbuhuPG/niiCCVWWXDjGNDKXQTNq6BOMeIUTMzztNX+i
 hCWgn24iUKom94srxSpGcpN0x/2nWwuaL3ZBJbACCrGEtz6NvN
 6TBw+J3BCjOQg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-01-23 at 11:01 +0800, Michael Wang wrote: 
> On 01/22/2013 07:34 PM, Mike Galbraith wrote:
>  I suppose it's A, so my logical is:
> >> 1. find idle cpu in prev domain.
> >> 2. if failed and affine, find idle cpu in current domain.
> > 
> > Hm.  If cpu and prev_cpu are cache affine, you already searched both.
> > 
> 
> Well, it's true if affine cpus means their sd topology are always same,
> but do we have a promise on it?

Ignore that, I think apple/orange communication happened.

-Mike



