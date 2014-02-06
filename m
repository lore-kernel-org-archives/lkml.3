Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825AbaBFRRX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Feb 2014 12:17:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:52572 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752045AbaBFRRV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Feb 2014 12:17:21 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140206120843.5a8b2d7928243f52436ac02c@canb.auug.org.au>
References: <20140206120843.5a8b2d7928243f52436ac02c@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Huston <jhuston@redhat.com>
Subject: Re: linux-next: build failure after merge of the fscache tree
Date: Thu, 06 Feb 2014 17:17:16 +0000
Message-ID: <20893.1391707036@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> After merging the fscache tree, today's linux-next build (x86_64
> allmodconfig) failed like this:

Yep.  I'd forgotten that branch was in linux-next.  I've moved the patches to
fscache-experimental so that they don't pester Fengguang either.

David
