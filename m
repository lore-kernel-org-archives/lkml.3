Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751339AbaKCXgU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 18:36:20 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:37578 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706AbaKCXgS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 18:36:18 -0500
Date: Mon, 3 Nov 2014 15:36:15 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Hillf Danton <hillf.zj@alibaba-inc.com>
cc: Michal Hocko <mhocko@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: [RFC patch] mm: hugetlb: fix __unmap_hugepage_range
In-Reply-To: <028701cff4c2$3e9e2ca0$bbda85e0$@alibaba-inc.com>
Message-ID: <alpine.DEB.2.10.1411031536040.7733@chino.kir.corp.google.com>
References: <028701cff4c2$3e9e2ca0$bbda85e0$@alibaba-inc.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 31 Oct 2014, Hillf Danton wrote:

> First, after flushing TLB, we have no need to scan pte from start again.
> Second, before bail out loop, the address is forwarded one step.
> 
> Signed-off-by: Hillf Danton <hillf.zj@alibaba-inc.com>

Acked-by: David Rientjes <rientjes@google.com>
