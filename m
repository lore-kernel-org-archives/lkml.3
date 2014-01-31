Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbaAaCRB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 21:17:01 -0500
Received: from mail-ig0-f178.google.com ([209.85.213.178]:65485 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753418AbaAaCQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 21:16:59 -0500
Message-ID: <1391134615.28432.83.camel@edumazet-glaptop2.roam.corp.google.com>
Subject: Re: kmem_cache_alloc panic in 3.10+
From: Eric Dumazet <eric.dumazet@gmail.com>
To: dormando <dormando@rydia.net>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alexei Starovoitov <ast@plumgrid.com>
Date: Thu, 30 Jan 2014 18:16:55 -0800
In-Reply-To: <alpine.DEB.2.02.1401292301070.5905@dtop>
References: <alpine.DEB.2.10.1401180036020.18419@dinf>
	 <1390062576.31367.519.camel@edumazet-glaptop2.roam.corp.google.com>
	 <alpine.DEB.2.02.1401181101220.579@dtop>
	 <alpine.DEB.2.02.1401292301070.5905@dtop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-01-29 at 23:05 -0800, dormando wrote:

> We hit the routing code fairly hard. Any hints for what to look at or how
> to instrument it? Or if it's fixed already? It's a real pain to iterate
> since it takes ~30 days to crash, usually. Sometimes.

I really wonder... it looks like a possible in SLUB. (might be already
fixed)

Could you try using SLAB instead ?


