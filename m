Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936745Ab3DJOLi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 10:11:38 -0400
Received: from a9-74.smtp-out.amazonses.com ([54.240.9.74]:34786 "EHLO
	a9-74.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935800Ab3DJOLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 10:11:37 -0400
X-Greylist: delayed 664 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Apr 2013 10:11:36 EDT
Date: Wed, 10 Apr 2013 14:00:31 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Pekka Enberg <penberg@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
In-Reply-To: <20130410073143.GF5872@lge.com>
Message-ID: <0000013df43f6fe0-8b71a9f4-bad1-417e-ab44-797c5ba2aecd-000000@email.amazonses.com>
References: <1364355032.6345.200.camel@gandalf.local.home> <20130327061351.GB17125@lge.com> <alpine.DEB.2.02.1303281227520.16200@gentwo.org> <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
 <CAP=VYLr4i=39ywFCrmG-XuvUFmmXpyj6dYgG44JJoUJhpN6uuQ@mail.gmail.com> <alpine.DEB.2.02.1304011025550.12690@gentwo.org> <0000013dc63b3a87-6ce88b75-d011-407e-8dde-da73c3a7f5fd-000000@email.amazonses.com> <20130402004217.GA16699@lge.com>
 <1365424372.25498.6.camel@gandalf.local.home> <CAOJsxLH2axjptbMj9caH0Wo_OqPZRVB20q7uT6f9dVtPZZxb_w@mail.gmail.com> <20130410073143.GF5872@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.10-54.240.9.74
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 10 Apr 2013, Joonsoo Kim wrote:

> > Christoph, Joonsoo, comments?
>
> Steven's comment is reasonable to me.
>
> If there is no objection from Christoph,
> let's drop a patch in which I implement Christoph's idea.

Fine with me.

I do not like passing a reference just because we have to
return an additional counter. Adds a lot of overhead.


