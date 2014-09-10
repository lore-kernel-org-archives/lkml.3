Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849AbaIJTC7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 15:02:59 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:54037 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701AbaIJTC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 15:02:56 -0400
Date: Wed, 10 Sep 2014 12:02:53 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Mel Gorman <mgorman@suse.de>
cc: Andrew Morton <akpm@linuxfoundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, Rik van Riel <riel@redhat.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: Make paranoid check in move_freepages
 a VM_BUG_ON
In-Reply-To: <20140909145228.GB12309@suse.de>
Message-ID: <alpine.DEB.2.02.1409101202400.27173@chino.kir.corp.google.com>
References: <20140909145228.GB12309@suse.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Sep 2014, Mel Gorman wrote:

> Since 2.6.24 there has been a paranoid check in move_freepages that looks
> up the zone of two pages. This is a very slow path and the only time I've
> seen this bug trigger recently is when memory initialisation was broken
> during patch development. Despite the fact it's a slow path, this patch
> converts the check to a VM_BUG_ON anyway as it is served its purpose by now.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: David Rientjes <rientjes@google.com>
