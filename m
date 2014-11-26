Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234AbaKZLqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 06:46:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34755 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaKZLqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 06:46:39 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <87y4qy7wci.fsf@x220.int.ebiederm.org>
References: <87y4qy7wci.fsf@x220.int.ebiederm.org> <20141125005255.4974.54193.stgit@pluto.fritz.box> <20141125010734.4974.85347.stgit@pluto.fritz.box> <20141125215248.GA7958@redhat.com> <20141125220637.GA10008@redhat.com>
To: ebiederm@xmission.com (Eric W. Biederman)
Cc: dhowells@redhat.com, Oleg Nesterov <oleg@redhat.com>,
        Ian Kent <ikent@redhat.com>,
        Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "J. Bruce Fields" <bfields@fieldses.org>,
        Stanislav Kinsbursky <skinsbursky@parallels.com>,
        Trond Myklebust <trond.myklebust@primarydata.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [RFC PATCH 3/4] kmod - add call_usermodehelper_ns() helper
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <1368.1417002382.1@warthog.procyon.org.uk>
Date: Wed, 26 Nov 2014 11:46:22 +0000
Message-ID: <1369.1417002382@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eric W. Biederman <ebiederm@xmission.com> wrote:

> Ian if we were to merge this I believe you would win the award for
> easiest path to a root shell.

Is there any particular reason the upcalled program has to be run as root?
Could the kernel not run it as something else - perhaps the caller's UID,GID
or even something anonymous?

Also, call_sbin_request_key() could be given a parameter to call something
other than /sbin/request-key, and key_type::request_key could be used.

David
