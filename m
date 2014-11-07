Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752977AbaKGWKo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 17:10:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:47909 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752488AbaKGWKm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 17:10:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <2455443.WUExuKDC0I@sifl>
References: <2455443.WUExuKDC0I@sifl> <20141105154217.2555.578.stgit@warthog.procyon.org.uk> <20141105154228.2555.55814.stgit@warthog.procyon.org.uk>
To: Paul Moore <paul@paul-moore.com>
Cc: dhowells@redhat.com, linux-unionfs@vger.kernel.org, selinux@tycho.nsa.gov,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/7] Security: Provide copy-up security hooks for unioned files
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3205.1415398234.1@warthog.procyon.org.uk>
Date: Fri, 07 Nov 2014 22:10:34 +0000
Message-ID: <3206.1415398234@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore <paul@paul-moore.com> wrote:

> This didn't occur to me earlier, but we may want to pick a different phrase
> to use instead of "copy_up" as that has a special meaning for some
> security/MLS folks...

It does?

security_inode_make_union()?

David


