Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755061AbaKOFmk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Nov 2014 00:42:40 -0500
Received: from message.langara.bc.ca ([209.87.29.115]:60480 "EHLO
	message.langara.bc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740AbaKOFmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Nov 2014 00:42:35 -0500
X-Greylist: delayed 3600 seconds by postgrey-1.27 at vger.kernel.org; Sat, 15 Nov 2014 00:42:35 EST
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-disposition: inline
Content-type: text/plain; charset=us-ascii
From: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Davidlohr Bueso <davidlohr@hp.com>,
        Manfred Spraul <manfred@colorfullife.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Doug Ledford <dledford@redhat.com>, linux-newbie@vger.kernel.org
Message-id: <fb7fa4d76314.5466d9ba@langara.bc.ca>
Date: Sat, 15 Nov 2014 04:42:34 +0000 (GMT)
X-Mailer: Sun Java(tm) System Messenger Express 6.3-6.03 (built Mar 14 2008;
 32bit)
Content-language: en
Subject: Re: [PATCH 1/1] ipc/mqueue.c: Drag unneeded code out of locks
X-Accept-Language: en
In-reply-to: <20141111162146.6e72c3fb0858df4945096c47@linux-foundation.org>
References: <fae396b9bc15.545c5b55@langara.bc.ca>
 <20141111162146.6e72c3fb0858df4945096c47@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, thank you for the criticism.

> It's probably better to do this as three or four separate patches.

Really? Alright if you insist I'll do the next version as multiple
patches.

> Well yes, that's what EMFILE means but "too_many_open_files" doesn't
> make sense in this context!

Fair enough, I'll rename it in the next version.

> Thatsabug.  It only requires CAP_SYS_RESOURCE if we're trying with
> queues_count >= queues_max.

Right, that was dumb of me.

> This test isn't really needed.

I don't follow. If the queue creation is not rejected then the
resource user has to be accounted for right? And we can't add the
resource to accounting if it is not created right?

Thank you,
Steven Stewart-Gallus
