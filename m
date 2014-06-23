Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaFWHw2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 03:52:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61490 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820AbaFWHw0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 03:52:26 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140623005249.21714.91524.stgit@notabene.brown>
References: <20140623005249.21714.91524.stgit@notabene.brown> <20140623004945.21714.26253.stgit@notabene.brown>
To: NeilBrown <neilb@suse.de>
Cc: dhowells@redhat.com, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>, linux-cifs@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>, Steve French <sfrench@samba.org>,
        Steven Whitehouse <swhiteho@redhat.com>
Subject: Re: [PATCH 1/2] SCHED: remove proliferation of wait_on_bit action functions.
Date: Mon, 23 Jun 2014 08:51:47 +0100
Message-ID: <5915.1403509907@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Acked-by: David Howells <dhowells@redhat.com> (fscache, keys)
