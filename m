Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755277AbaKOFon (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:44:43 -0500
Received: from message.langara.bc.ca ([209.87.29.115]:60547 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707AbaKOFol (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:44:41 -0500
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: Davidlohr Bueso <dave@stgolabs.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Doug Ledford <dledford@redhat.com>, linux-newbie@vger.kernel.org
Message-id: <fbb3e8aa49d6.5466da38@langara.bc.ca>
Date: Sat, 15 Nov 2014 04:44:40 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Re: [PATCH 1/1] ipc/mqueue.c: Drag unneeded code out of locks
X-Accept-Language: en
In-reply-to: <1415780201.24725.2.camel@linux-t7sj.site>
References: <fae396b9bc15.545c5b55@langara.bc.ca>
 <1415780201.24725.2.camel@linux-t7sj.site>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> What's the benefit here? Seems very risky at very little gain.
>
> The juice ain't worth the squeeze. NAK

Hello,

It is fair to argue that these changes are too tiny to be very
meaningful for performance but the other goal of this patch was also
to make the code look cleaner and easier for me and other people to
understand. I hope that is a reasonable desire.

It is not fair to argue that these changes are risky. If it is risky
for a person to add code then the code is too complicated to
understand and should be rewritten or tests or formal methods should
be used to verify correctness.

Are you suggesting that the mqueue subsystem is too complicated for
one to understand changes made to it and that it needs to be cleaned
up a bit? I am trying to make the code easier to understand with this
patch.

Or that you'd want some more testing of the mqueue subsystem or the
changes I made too it?

Or that you'd want some more formal methods to make the code easier to
verify? I suppose the area of code use a few extra sparse annotations.

Thank you,
Steven Stewart-Gallus

