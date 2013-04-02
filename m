Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762186Ab3DBTYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:24:05 -0400
Received: from a9-42.smtp-out.amazonses.com ([54.240.9.42]:53119 "EHLO
	a9-42.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761237Ab3DBTYB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:24:01 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 15:24:01 EDT
Date: Tue, 2 Apr 2013 19:17:49 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Pekka Enberg <penberg@kernel.org>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] slub: correct to calculate num of acquired objects
 in get_partial_node()
In-Reply-To: <CAOJsxLH7Vhi1ady+uu5Vn-o5bW4rd6MiJZ1Okjqo2nX-JjgXAQ@mail.gmail.com>
Message-ID: <0000013dcc2f1037-3e5332ff-5a67-4db8-bcbe-c1c163ef2914-000000@email.amazonses.com>
References: <1358755287-3899-1-git-send-email-iamjoonsoo.kim@lge.com> <20130319051045.GB8858@lge.com> <CAOJsxLH7Vhi1ady+uu5Vn-o5bW4rd6MiJZ1Okjqo2nX-JjgXAQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 54.240.9.42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Pekka Enberg wrote:

> On Tue, Mar 19, 2013 at 7:10 AM, Joonsoo Kim <iamjoonsoo.kim@lge.com> wrote:
> > Could you pick up 1/3, 3/3?
> > These are already acked by Christoph.
> > 2/3 is same effect as Glauber's "slub: correctly bootstrap boot caches",
> > so should skip it.
>
> Applied, thanks!

Could you also put in

1. The fixes for the hotpath using preempt/enable/disable that were
discussed with the RT folks a couple of months ago.

2. The fixes from the slab next branch.

