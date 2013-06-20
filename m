Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab3FTGi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 02:38:29 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:47809 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751921Ab3FTGi2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 02:38:28 -0400
Date: Thu, 20 Jun 2013 02:38:17 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Chanho Min <chanho.min@lge.com>
Cc: "'Zhang Yanfei'" <zhangyanfei@cn.fujitsu.com>,
        "'Andrew Morton'" <akpm@linux-foundation.org>, iamjoonsoo.kim@lge.com,
        linux-kernel@vger.kernel.org, "'Linux MM'" <linux-mm@kvack.org>,
        "'Mel Gorman'" <mgorman@suse.de>
Subject: Re: [PATCH 0/3] mm, vmalloc: cleanup for vmap block
Message-ID: <20130620063817.GA1079@cmpxchg.org>
References: <51B1AD2F.4030702@cn.fujitsu.com>
 <006801ce6577$a50317c0$ef094740$@min@lge.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006801ce6577$a50317c0$ef094740$@min@lge.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 10, 2013 at 10:12:57AM +0900, Chanho Min wrote:
> > This patchset is a cleanup for vmap block. And similar/same
> > patches has been submitted before:
> > - Johannes Weiner's patch: https://lkml.org/lkml/2011/4/14/619
> > - Chanho Min's patch: https://lkml.org/lkml/2013/2/6/810
> 
> This is exactly the same patch as mine. The previous two patches are
> should be concluded.

Ping.  This code is identical, it should credit Chanho as the original
author.  And I agree that the patches should be folded into one patch.

Thanks!
