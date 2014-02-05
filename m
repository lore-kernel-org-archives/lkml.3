Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609AbaBEAcV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 19:32:21 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:2164 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751339AbaBEAcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 19:32:20 -0500
Message-ID: <1391560337.2501.0.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [patch] mm, hugetlb: mark some bootstrap functions as __init
From: Davidlohr Bueso <davidlohr@hp.com>
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Date: Tue, 04 Feb 2014 16:32:17 -0800
In-Reply-To: <alpine.DEB.2.02.1402041612120.14962@chino.kir.corp.google.com>
References: <alpine.DEB.2.02.1402041612120.14962@chino.kir.corp.google.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-04 at 16:13 -0800, David Rientjes wrote:
> Both prep_compound_huge_page() and prep_compound_gigantic_page() are only
> called at bootstrap and can be marked as __init.
> 
> The __SetPageTail(page) in prep_compound_gigantic_page() happening before
> page->first_page is initialized is not concerning since this is
> bootstrap.
> 
> Signed-off-by: David Rientjes <rientjes@google.com>

Reviewed-by: Davidlohr Bueso <davidlohr@hp.com>

