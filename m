Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759725AbaGCVsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 17:48:45 -0400
Received: from mail-ig0-f180.google.com ([209.85.213.180]:53920 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaGCVso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 17:48:44 -0400
Date: Thu, 3 Jul 2014 14:48:42 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: commit message 8a5b20aebaa3 refers to non-existing commit ?
In-Reply-To: <53B5CDDD.8000009@gmx.de>
Message-ID: <alpine.DEB.2.02.1407031445390.10658@chino.kir.corp.google.com>
References: <53B5CDDD.8000009@gmx.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="531381512-666889341-1404424123=:10658"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--531381512-666889341-1404424123=:10658
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT

On Thu, 3 Jul 2014, Toralf Förster wrote:

> in 
> commit 8a5b20aebaa3d0ade5b8381e64d35fb777b7b355
> Author: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Date:   Wed Jul 2 15:22:35 2014 -0700
> 
>     slub: fix off by one in number of slab tests
> 
> 
> you stated:
> 
>     Fixes 91cb69620284 ("slub: make dead memcg caches discard free slabs
>     immediately").
> 
> 
> which I cannot find in main line currently. Pls could you point me to that commit ?
> 

It hasn't been pushed to Linus yet, it's still sitting in the -mm tree:
http://ozlabs.org/~akpm/mmotm/broken-out/slub-make-dead-memcg-caches-discard-free-slabs-immediately.patch

Not sure where the SHA1 came from, probably linux-next.  So the fix made 
it to Linus before the offending commit, but the code is still correct.
--531381512-666889341-1404424123=:10658--
