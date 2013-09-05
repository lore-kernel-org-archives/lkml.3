Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3IEOd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Sep 2013 10:33:58 -0400
Received: from a9-99.smtp-out.amazonses.com ([54.240.9.99]:58986 "EHLO
	a9-99.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752345Ab3IEOd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Sep 2013 10:33:57 -0400
Date: Thu, 5 Sep 2013 14:33:56 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] slab: implement byte sized indexes for the freelist
 of a slab
In-Reply-To: <20130905065552.GA6384@lge.com>
Message-ID: <00000140ee8b386a-f9b8a845-58db-482e-8c63-20fb24404dc8-000000@email.amazonses.com>
References: <CAAmzW4N1GXbr18Ws9QDKg7ChN5RVcOW9eEv2RxWhaEoHtw=ctw@mail.gmail.com> <1378111138-30340-1-git-send-email-iamjoonsoo.kim@lge.com> <00000140e42dcd61-00e6cf6a-457c-48bd-8bf7-830133923564-000000@email.amazonses.com> <20130904083305.GC16355@lge.com>
 <20130905065552.GA6384@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.09.05-54.240.9.99
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 5 Sep 2013, Joonsoo Kim wrote:

> I think that all patchsets deserve to be merged, since it reduces memory usage and
> also improves performance. :)

Could you clean things up etc and the repost the patchset? This time do
*not* do this as a response to an earlier email but start the patchset
with new thread id. I think some people are not seeing this patchset.

There is a tool called "quilt" that can help you send the patchset.

	quilt mail

Tools for git to do the same also exist.
