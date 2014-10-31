Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161033AbaJaPPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 11:15:16 -0400
Received: from resqmta-ch2-08v.sys.comcast.net ([69.252.207.40]:32802 "EHLO
	resqmta-ch2-08v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932570AbaJaPPO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 11:15:14 -0400
Date: Fri, 31 Oct 2014 10:15:11 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Markos Chandras <Markos.Chandras@imgtec.com>
Subject: Re: [PATCH] mm/slab: reverse iteration on find_mergeable()
In-Reply-To: <1414742954-14889-1-git-send-email-iamjoonsoo.kim@lge.com>
Message-ID: <alpine.DEB.2.11.1410311014570.14859@gentwo.org>
References: <1414742954-14889-1-git-send-email-iamjoonsoo.kim@lge.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Joonsoo Kim wrote:

> To prevent this situation, this patch reverses iteration order in
> find_mergeable() to find frequently used kmem_caches. This change
> helps to merge kmem_cache to frequently used kmem_caches, such as
> kmalloc kmem_caches.

Acked-by: Christoph Lameter <cl@linux.com>
