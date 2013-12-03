Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754047Ab3LCQVo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 11:21:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5888 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752257Ab3LCQVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 11:21:40 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
References: <20131203145250.30689.28039.stgit@warthog.procyon.org.uk>
To: torvalds@linux-foundation.org, jmorris@namei.org
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH0/5] Keys patches
Date: Tue, 03 Dec 2013 16:21:03 +0000
Message-ID: <31624.1386087663@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The patches can be found here:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-devel

and I forgot to remove the "[RFC]" from the old cover letter.

Test scripts are included in the keyutils repo on a devel branch:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/keyutils.git/log/?h=tests-devel

David
