Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186AbaKLIRE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 03:17:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:60267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752016AbaKLIRC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 03:17:02 -0500
Message-ID: <1415780201.24725.2.camel@linux-t7sj.site>
Subject: Re: [PATCH 1/1] ipc/mqueue.c: Drag unneeded code out of locks
From: Davidlohr Bueso <dave@stgolabs.net>
To: Steven Stewart-Gallus <sstewartgallus00@mylangara.bc.ca>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Manfred Spraul <manfred@colorfullife.com>,
        "J. Bruce Fields" <bfields@redhat.com>,
        Doug Ledford <dledford@redhat.com>, linux-newbie@vger.kernel.org
Date: Wed, 12 Nov 2014 00:16:41 -0800
In-Reply-To: <fae396b9bc15.545c5b55@langara.bc.ca>
References: <fae396b9bc15.545c5b55@langara.bc.ca>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-11-07 at 05:40 +0000, Steven Stewart-Gallus wrote:
> This shouldn't be too controversial. I simply looked for where there
> was a tiny bit of waste in the message queue code.

What's the benefit here? Seems very risky at very little gain.

The juice ain't worth the squeeze. NAK

