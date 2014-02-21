Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755069AbaBULcw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 06:32:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbaBULcv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 06:32:51 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20140221174238.acefa05c8a5e71b06155d32d@canb.auug.org.au>
References: <20140221174238.acefa05c8a5e71b06155d32d@canb.auug.org.au>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm-current tree with the sparc tree
Date: Fri, 21 Feb 2014 11:32:44 +0000
Message-ID: <28092.1392982364@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Today's linux-next merge of the akpm-current tree got a conflict in
> drivers/sbus/char/jsflash.c between commit 967f038e491b ("Sparc:
> sparc_cpu_model isn't in asm/system.h any more [ver #2]") from the sparc
> tree and commit 695f43eb1721 ("asm/system.h: sparc: sparc_cpu_model isn't
> in asm/system.h any more") from the akpm-current tree.

I think Andrew's is an old version.

David
