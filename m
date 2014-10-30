Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760679AbaJ3OrR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 10:47:17 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51192 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760159AbaJ3OrP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 10:47:15 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com>
References: <CAJfpegv5dqfgze-9pxDD-O19tctS-4P12NsO2oCo5SF1bqhhHA@mail.gmail.com> <20141030141004.28203.79687.stgit@warthog.procyon.org.uk>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: dhowells@redhat.com, Al Viro <viro@zeniv.linux.org.uk>,
        Linux-Fsdevel <linux-fsdevel@vger.kernel.org>,
        linux-unionfs@vger.kernel.org,
        Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Overlayfs: ovl_fill_merge() should use container_of() rather than direct cast
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <5759.1414680426.1@warthog.procyon.org.uk>
Date: Thu, 30 Oct 2014 14:47:06 +0000
Message-ID: <5760.1414680426@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> wrote:

> Okay, but why don't we have a typed argument of actor then?

You should ask that one to Al.

David
