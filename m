Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754509AbaBAAcF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 19:32:05 -0500
Received: from mail-pb0-f41.google.com ([209.85.160.41]:36974 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753235AbaBAAcD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 19:32:03 -0500
Message-ID: <1391214720.28432.88.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: kmem_cache_alloc panic in 3.10+
From: Eric Dumazet <eric.dumazet@gmail.com>
To: dormando <dormando@rydia.net>
Cc: David Rientjes <rientjes@google.com>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Alexei Starovoitov <ast@plumgrid.com>
Date: Fri, 31 Jan 2014 16:32:00 -0800
In-Reply-To: <alpine.DEB.2.02.1401311537290.17834@dtop>
References: <alpine.DEB.2.10.1401180036020.18419@dinf>
	 <1390062576.31367.519.camel@edumazet-glaptop2.roam.corp.google.com>
	 <alpine.DEB.2.02.1401181101220.579@dtop>
	 <alpine.DEB.2.02.1401292301070.5905@dtop>
	 <1391134615.28432.83.camel@edumazet-glaptop2.roam.corp.google.com>
	 <CAADnVQ+vCikFY-te2U8wD+ustNW-o6Cqs8ye5ZfyNcU6vPQzNA@mail.gmail.com>
	 <alpine.DEB.2.10.1401301951060.5516@dinf>
	 <alpine.DEB.2.02.1401311315110.27318@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1401311407190.17834@dtop>
	 <alpine.DEB.2.02.1401311521170.18890@chino.kir.corp.google.com>
	 <alpine.DEB.2.02.1401311537290.17834@dtop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-01-31 at 15:43 -0800, dormando wrote:

> chpxchg_double()? that's not related to the 62713c4b fix right?
> 
> I'll see what I can do.. it's going to take a long time to iterate on this
> though.

Dont know about this commit.

I was more thinking about c25f195e828f847735c7626b5693ddc3b853d245
("slub: Check for page NULL before doing the node_match check")


