Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752349Ab3LCIqk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 03:46:40 -0500
Received: from smtp2.it.da.ut.ee ([193.40.5.67]:35930 "EHLO smtp2.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751987Ab3LCIqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 03:46:39 -0500
Date: Tue, 3 Dec 2013 10:46:35 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Christoph Lameter <cl@linux.com>
cc: David Rientjes <rientjes@google.com>, Pekka Enberg <penberg@kernel.org>,
        Matt Mackall <mpm@selenic.com>,
        Linux Kernel list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: Slab BUG with DEBUG_* options
In-Reply-To: <00000142b4b122b4-377a8c1e-32e1-401e-a9c0-caa7e8ade31c-000000@email.amazonses.com>
Message-ID: <alpine.SOC.1.00.1312031045510.3485@math.ut.ee>
References: <alpine.SOC.1.00.1311300125490.6363@math.ut.ee> <alpine.DEB.2.02.1311301428390.18027@chino.kir.corp.google.com> <00000142b4b122b4-377a8c1e-32e1-401e-a9c0-caa7e8ade31c-000000@email.amazonses.com>
User-Agent: Alpine 1.00 (SOC 882 2007-12-20)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Does this patch from 3.13 fix it?
> 
> commit c6f58d9b362b45c52afebe4342c9137d0dabe47f
> Author: Christoph Lameter <cl@linux.com>
> Date:   Thu Nov 7 16:29:15 2013 +0000
> 
>     slub: Handle NULL parameter in kmem_cache_flags

I do not think so - it is for slub but this machine uses slab.

-- 
Meelis Roos (mroos@linux.ee)
