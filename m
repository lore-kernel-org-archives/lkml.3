Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab3AORBR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 12:01:17 -0500
Received: from mx1.redhat.com ([209.132.183.28]:1448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697Ab3AORBO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 12:01:14 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130115111451.GB27222@gmail.com>
References: <20130115111451.GB27222@gmail.com> <1358210328-16726-1-git-send-email-dinggnu@gmail.com> <9706.1358246363@warthog.procyon.org.uk>
To: Cong Ding <dinggnu@gmail.com>
Cc: dhowells@redhat.com, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gpu: drm/nouveau/nouveau_fence.c: remove unnecessary null pointer check
Date: Tue, 15 Jan 2013 17:00:47 +0000
Message-ID: <13598.1358269247@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cong Ding <dinggnu@gmail.com> wrote:

> > > the variable sender is dereferenced in line 190, so it is no reason to check
> > > null again in line 198.
> > 
> > Did you mean "The variable 'chan'"?
> sorry, my fault. so should I send a new version to correct the typo?

Yep.

David
