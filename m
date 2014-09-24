Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755268AbaIXALB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 20:11:01 -0400
Received: from mail-ig0-f174.google.com ([209.85.213.174]:61257 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192AbaIXALA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 20:11:00 -0400
Date: Tue, 23 Sep 2014 17:10:57 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Christoph Lameter <cl@linux.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, a.elovikov@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, slab: initialize object alignment on cache
 creation
In-Reply-To: <alpine.DEB.2.11.1409231821050.32451@gentwo.org>
Message-ID: <alpine.DEB.2.02.1409231710430.8339@chino.kir.corp.google.com>
References: <20140923141940.e2d3840f31d0f8850b925cf6@linux-foundation.org> <alpine.DEB.2.02.1409231439190.22630@chino.kir.corp.google.com> <alpine.DEB.2.11.1409231821050.32451@gentwo.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, Christoph Lameter wrote:

> > The proper alignment defaults to BYTES_PER_WORD and can be overridden by
> > SLAB_RED_ZONE or the alignment specified by the caller.
> 
> Where does it default to BYTES_PER_WORD in __kmem_cache_create?
> 

Previous to commit 4590685546a3 ("mm/sl[aou]b: Common alignment code") 
which introduced this issue.
