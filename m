Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932558Ab3DBToq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:44:46 -0400
Received: from a9-70.smtp-out.amazonses.com ([54.240.9.70]:34984 "EHLO
	a9-70.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761236Ab3DBToo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:44:44 -0400
X-Greylist: delayed 1162 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 15:44:44 EDT
Date: Tue, 2 Apr 2013 19:25:20 +0000
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: Joonsoo Kim <iamjoonsoo.kim@lge.com>
cc: Paul Gortmaker <paul.gortmaker@windriver.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <clark@redhat.com>, Pekka Enberg <penberg@kernel.org>
Subject: Re: [RT LATENCY] 249 microsecond latency caused by slub's
 unfreeze_partials() code.
In-Reply-To: <20130402004217.GA16699@lge.com>
Message-ID: <0000013dcc35f310-d338600d-8a5a-4c95-9770-af4b8d81e103-000000@email.amazonses.com>
References: <0000013da2ce20f8-0e3a64ef-67ed-4ab4-9f20-b77980c876c3-000000@email.amazonses.com> <1364236355.6345.185.camel@gandalf.local.home> <20130327025957.GA17125@lge.com> <1364355032.6345.200.camel@gandalf.local.home> <20130327061351.GB17125@lge.com>
 <alpine.DEB.2.02.1303281227520.16200@gentwo.org> <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com> <CAP=VYLr4i=39ywFCrmG-XuvUFmmXpyj6dYgG44JJoUJhpN6uuQ@mail.gmail.com> <alpine.DEB.2.02.1304011025550.12690@gentwo.org>
 <0000013dc63b3a87-6ce88b75-d011-407e-8dde-da73c3a7f5fd-000000@email.amazonses.com> <20130402004217.GA16699@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 54.240.9.70
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Apr 2013, Joonsoo Kim wrote:

> We need one more fix for correctness.
> When available is assigned by put_cpu_partial, it doesn't count cpu slab's objects.
> Please reference my old patch.
>
> https://lkml.org/lkml/2013/1/21/64

Could you update your patch and submit it again?

