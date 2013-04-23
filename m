Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab3DWXQs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 19:16:48 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:59981 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752241Ab3DWXQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 19:16:46 -0400
Date: Tue, 23 Apr 2013 16:16:44 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Aaron Tomlin <atomlin@redhat.com>
cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, Rik <riel@redhat.com>,
        Rafael Aquini <aquini@redhat.com>
Subject: Re: [Patch v2] mm: slab: Verify the nodeid passed to
 ____cache_alloc_node
In-Reply-To: <1014891011.990074.1366727496599.JavaMail.root@redhat.com>
Message-ID: <alpine.DEB.2.02.1304231616270.3855@chino.kir.corp.google.com>
References: <1014891011.990074.1366727496599.JavaMail.root@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Apr 2013, Aaron Tomlin wrote:

> mm: slab: Verify the nodeid passed to ____cache_alloc_node
>     
> If the nodeid is > num_online_nodes() this can cause an
> Oops and a panic(). The purpose of this patch is to assert
> if this condition is true to aid debugging efforts rather
> than some random NULL pointer dereference or page fault.
>     
> Signed-off-by: Aaron Tomlin <atomlin@redhat.com>
> Reviewed-by: Rik van Riel <riel@redhat.com>
> 

Acked-by: David Rientjes <rientjes@google.com>
