Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbbAMRwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2015 12:52:05 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57433 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753164AbbAMRwD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2015 12:52:03 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <CAB9dFdvPM-qbhPOZ=4KLs2OB5PYSzaog6byzCvV8N-72uxJ5cQ@mail.gmail.com>
References: <CAB9dFdvPM-qbhPOZ=4KLs2OB5PYSzaog6byzCvV8N-72uxJ5cQ@mail.gmail.com> <20150113163832.24625.95960.stgit@warthog.procyon.org.uk>
To: Marc Dionne <marc.c.dionne@gmail.com>
Cc: dhowells@redhat.com, jesper.nilsson@axis.com,
        Al Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-cris-kernel@axis.com
Subject: Re: [PATCH] VFS: Convert file->f_dentry->d_inode to file_inode()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28856.1421171513.1@warthog.procyon.org.uk>
Date: Tue, 13 Jan 2015 17:51:53 +0000
Message-ID: <28857.1421171513@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Dionne <marc.c.dionne@gmail.com> wrote:

> Shouldn't that be file_inode(file) ?

Bah, yes.
