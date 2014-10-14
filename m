Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060AbaJNAOa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 20:14:30 -0400
Received: from lgeamrelo04.lge.com ([156.147.1.127]:57038 "EHLO
	lgeamrelo04.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752985AbaJNAO2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 20:14:28 -0400
X-Original-SENDERIP: 10.177.222.213
X-Original-MAILFROM: iamjoonsoo.kim@lge.com
Date: Tue, 14 Oct 2014 09:14:54 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: David Miller <davem@davemloft.net>
Cc: mroos@linux.ee, linux-kernel@vger.kernel.org, cl@linux.com,
        penberg@kernel.org, rientjes@google.com, akpm@linux-foundation.org,
        linux-mm@kvack.org, sparclinux@vger.kernel.org
Subject: Re: unaligned accesses in SLAB etc.
Message-ID: <20141014001454.GA12575@js1304-P5Q-DELUXE>
References: <20141012.132012.254712930139255731.davem@davemloft.net>
 <alpine.LRH.2.11.1410132320110.9586@adalberg.ut.ee>
 <20141013235219.GA11191@js1304-P5Q-DELUXE>
 <20141013.200416.641735303627599182.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141013.200416.641735303627599182.davem@davemloft.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 08:04:16PM -0400, David Miller wrote:
> From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> Date: Tue, 14 Oct 2014 08:52:19 +0900
> 
> > I'd like to know that your another problem is related to commit
> > bf0dea23a9c0 ("mm/slab: use percpu allocator for cpu cache").  So,
> > if the commit is reverted, your another problem is also gone
> > completely?
> 
> The other problem has been present forever.

Okay.
Thanks for notifying me.

Thanks.
