Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757894AbaJaKSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 06:18:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38889 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbaJaKSg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 06:18:36 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20141030163734.GE3021@tucsk.piliscsaba.szeredi.hu>
References: <20141030163734.GE3021@tucsk.piliscsaba.szeredi.hu> <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com> <20141030141004.28203.79687.stgit@warthog.procyon.org.uk> <5760.1414680426@warthog.procyon.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Overlayfs: ovl_fill_merge() should use container_of() rather than direct cast
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <13507.1414750707.1@warthog.procyon.org.uk>
Date: Fri, 31 Oct 2014 10:18:27 +0000
Message-ID: <13508.1414750707@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Subject: vfs: make first argument of dir_context.actor typed
> From: Miklos Szeredi <mszeredi@suse.cz>
> 
> Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>

Acked-by: David Howells <dhowells@redhat.com>
