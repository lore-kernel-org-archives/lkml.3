Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754325Ab3IKOW1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 10:22:27 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:57746 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752595Ab3IKOW0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 10:22:26 -0400
Date: Wed, 11 Sep 2013 14:22:25 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [REPOST PATCH 3/4] slab: introduce byte sized index for the
 freelist of a slab
In-Reply-To: <20130911010434.GB24671@lge.com>
Message-ID: <000001410d66d62b-d6711e2e-31e4-49da-8d20-efba10fc6a54-000000@email.amazonses.com>
References: <1378447067-19832-1-git-send-email-iamjoonsoo.kim@lge.com> <1378447067-19832-4-git-send-email-iamjoonsoo.kim@lge.com> <00000140f3fed229-f49b95d4-7087-476f-b2c9-37846749aad6-000000@email.amazonses.com> <20130909043217.GB22390@lge.com>
 <00000141032dea11-c5aa9c77-b2f2-4cab-b7a0-d37665a6cec8-000000@email.amazonses.com> <20130910054342.GB24602@lge.com> <0000014109c372c6-5f3c49d4-ce8b-4760-b80d-a32e042ec09b-000000@email.amazonses.com> <20130911010434.GB24671@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.11-54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Sep 2013, Joonsoo Kim wrote:

> Anyway, could you review my previous patchset, that is, 'overload struct slab
> over struct page to reduce memory usage'? I'm not sure whether your answer is
> ack or not.

I scanned over it before but I was not able to see if it was correct on
first glance. I will look at it again.

