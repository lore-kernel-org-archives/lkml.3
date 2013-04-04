Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761356Ab3DDOLG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 10:11:06 -0400
Received: from a9-78.smtp-out.amazonses.com ([54.240.9.78]:45281 "EHLO
	a9-78.smtp-out.amazonses.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1761305Ab3DDOLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 10:11:03 -0400
X-Greylist: delayed 1056 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Apr 2013 10:11:03 EDT
Date: Thu, 4 Apr 2013 13:53:25 +0000
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
In-Reply-To: <20130404005850.GC10683@lge.com>
Message-ID: <0000013dd552ca2b-986c7b7f-850e-4108-82e8-443695368b1d-000000@email.amazonses.com>
References: <20130327025957.GA17125@lge.com> <1364355032.6345.200.camel@gandalf.local.home> <20130327061351.GB17125@lge.com> <alpine.DEB.2.02.1303281227520.16200@gentwo.org> <0000013db20ca149-0064fbb8-2f81-4323-9095-a38f6abb79c5-000000@email.amazonses.com>
 <CAP=VYLr4i=39ywFCrmG-XuvUFmmXpyj6dYgG44JJoUJhpN6uuQ@mail.gmail.com> <alpine.DEB.2.02.1304011025550.12690@gentwo.org> <0000013dc63b3a87-6ce88b75-d011-407e-8dde-da73c3a7f5fd-000000@email.amazonses.com> <20130402004217.GA16699@lge.com>
 <0000013dcc35f310-d338600d-8a5a-4c95-9770-af4b8d81e103-000000@email.amazonses.com> <20130404005850.GC10683@lge.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-SES-Outgoing: 2013.04.04-54.240.9.78
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 4 Apr 2013, Joonsoo Kim wrote:

> Pekka alreay applied it.
> Do we need update?

Well I thought the passing of the count via lru.next would be something
worthwhile to pick up.

