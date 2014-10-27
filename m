Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaJ0PpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Oct 2014 11:45:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54399 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752458AbaJ0PpF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 11:45:05 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20141027144201.GD3021@tucsk.piliscsaba.szeredi.hu>
References: <20141027144201.GD3021@tucsk.piliscsaba.szeredi.hu> <20141027141935.GC3021@tucsk.piliscsaba.szeredi.hu> <5394.1414418718@warthog.procyon.org.uk> <6032.1414420761@warthog.procyon.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org
Subject: Re: Locking problem in overlayfs
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <12800.1414424690.1@warthog.procyon.org.uk>
Date: Mon, 27 Oct 2014 15:44:50 +0000
Message-ID: <12801.1414424690@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Yes, following (untested) patch should fix it:

Tested-by: David Howells <dhowells@redhat.com>
