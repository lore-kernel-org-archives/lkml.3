Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758248AbaGWXN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 19:13:57 -0400
Received: from mail-ig0-f173.google.com ([209.85.213.173]:36570 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532AbaGWXN4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 19:13:56 -0400
Date: Wed, 23 Jul 2014 16:13:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Gu Zheng <guz.fnst@cn.fujitsu.com>
cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] slab: fix the alias count(via sysfs) of slab cache
In-Reply-To: <1406087381-21400-1-git-send-email-guz.fnst@cn.fujitsu.com>
Message-ID: <alpine.DEB.2.02.1407231612290.1389@chino.kir.corp.google.com>
References: <1406087381-21400-1-git-send-email-guz.fnst@cn.fujitsu.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014, Gu Zheng wrote:

> We mark some slabs(e.g. kmem_cache_node) as unmergeable via setting
> refcount to -1, and their alias should be 0, not refcount-1, so correct
> it here.
> 
> Signed-off-by: Gu Zheng <guz.fnst@cn.fujitsu.com>

Acked-by: David Rientjes <rientjes@google.com>

s/slabs/slab caches/

The two slab caches of interest are kmem_cache and kmem_cache_node.
