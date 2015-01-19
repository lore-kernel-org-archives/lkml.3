Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667AbbASMHb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jan 2015 07:07:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57571 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751437AbbASMGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jan 2015 07:06:35 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20150116083433.GZ26817@axis.com>
References: <20150116083433.GZ26817@axis.com> <20150113175753.29073.20788.stgit@warthog.procyon.org.uk>
To: Jesper Nilsson <jesper.nilsson@axis.com>
Cc: dhowells@redhat.com, Jesper Nilsson <jespern@axis.com>,
        "viro@ZenIV.linux.org.uk" <viro@ZenIV.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-cris-kernel <linux-cris-kernel@axis.com>
Subject: Re: [PATCH] VFS: Convert file->f_dentry->d_inode to file_inode() [ver #2]
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <19165.1421669186.1@warthog.procyon.org.uk>
Date: Mon, 19 Jan 2015 12:06:26 +0000
Message-ID: <19166.1421669186@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesper Nilsson <jesper.nilsson@axis.com> wrote:

> Yes, compile works with this patch. Do you want me to take it through
> the CRIS tree or do you have any other tree in mind?

I can take it.

David
