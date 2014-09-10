Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537AbaIJUeJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2014 16:34:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:36658 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752825AbaIJUeG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2014 16:34:06 -0400
Message-ID: <5410B54E.1020607@redhat.com>
Date: Wed, 10 Sep 2014 16:32:14 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linuxfoundation.org>
CC: Johannes Weiner <hannes@cmpxchg.org>, David Rientjes <rientjes@google.com>,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: page_alloc: Make paranoid check in move_freepages
 a VM_BUG_ON
References: <20140909145228.GB12309@suse.de>
In-Reply-To: <20140909145228.GB12309@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/09/2014 10:52 AM, Mel Gorman wrote:
> Since 2.6.24 there has been a paranoid check in move_freepages that looks
> up the zone of two pages. This is a very slow path and the only time I've
> seen this bug trigger recently is when memory initialisation was broken
> during patch development. Despite the fact it's a slow path, this patch
> converts the check to a VM_BUG_ON anyway as it is served its purpose by now.
> 
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

