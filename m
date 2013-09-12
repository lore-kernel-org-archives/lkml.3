Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756463Ab3ILGwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 02:52:05 -0400
Received: from lgeamrelo01.lge.com ([156.147.1.125]:52927 "EHLO
	LGEAMRELO01.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061Ab3ILGwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 02:52:01 -0400
X-AuditID: 9c93017d-b7cdfae0000026c0-84-5231648f67a0
Date: Thu, 12 Sep 2013 15:52:25 +0900
From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
To: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 3/4] slab: introduce byte sized index for the
 freelist of a slab
Message-ID: <20130912065225.GB8055@lge.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com>
 <1378447067-19832-4-git-send-email-iamjoonsoo.kim@lge.com>
 <00000140f3fed229-f49b95d4-7087-476f-b2c9-37846749aad6-000000@email.amazonses.com>
 <20130909043217.GB22390@lge.com>
 <00000141032dea11-c5aa9c77-b2f2-4cab-b7a0-d37665a6cec8-000000@email.amazonses.com>
 <20130910054342.GB24602@lge.com>
 <0000014109c372c6-5f3c49d4-ce8b-4760-b80d-a32e042ec09b-000000@email.amazonses.com>
 <20130911010434.GB24671@lge.com>
 <000001410d66d62b-d6711e2e-31e4-49da-8d20-efba10fc6a54-000000@email.amazonses.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000001410d66d62b-d6711e2e-31e4-49da-8d20-efba10fc6a54-000000@email.amazonses.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 11, 2013 at 02:22:25PM +0000, Christoph Lameter wrote:
> On Wed, 11 Sep 2013, Joonsoo Kim wrote:
> 
> > Anyway, could you review my previous patchset, that is, 'overload struct slab
> > over struct page to reduce memory usage'? I'm not sure whether your answer is
> > ack or not.
> 
> I scanned over it before but I was not able to see if it was correct on
> first glance. I will look at it again.

Sounds good! Thanks :)
