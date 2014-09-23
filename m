Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757049AbaIWX2Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 19:28:16 -0400
Received: from resqmta-ch2-05v.sys.comcast.net ([69.252.207.37]:45437 "EHLO
	resqmta-ch2-05v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752732AbaIWX2P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 19:28:15 -0400
X-Greylist: delayed 365 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Sep 2014 19:28:15 EDT
Date: Tue, 23 Sep 2014 18:22:08 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: David Rientjes <rientjes@google.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Pekka Enberg <penberg@kernel.org>, a.elovikov@gmail.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [patch] mm, slab: initialize object alignment on cache
 creation
In-Reply-To: <alpine.DEB.2.02.1409231439190.22630@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.11.1409231821050.32451@gentwo.org>
References: <20140923141940.e2d3840f31d0f8850b925cf6@linux-foundation.org> <alpine.DEB.2.02.1409231439190.22630@chino.kir.corp.google.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Sep 2014, David Rientjes wrote:

> The proper alignment defaults to BYTES_PER_WORD and can be overridden by
> SLAB_RED_ZONE or the alignment specified by the caller.

Where does it default to BYTES_PER_WORD in __kmem_cache_create?
