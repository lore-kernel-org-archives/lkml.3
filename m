Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753190Ab3AULJo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 06:09:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752449Ab3AULJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 06:09:42 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <50F9E488.1000604@infradead.org>
References: <50F9E488.1000604@infradead.org> <20130118153707.0909fb9039e411acc1674c32@canb.auug.org.au>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: dhowells@redhat.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for Jan 18 (x509)
Date: Mon, 21 Jan 2013 11:09:24 +0000
Message-ID: <22325.1358766564@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Randy Dunlap <rdunlap@infradead.org> wrote:

> > Changes since 20130117:
> > 
> 
> on x86_64:
> 
> make[2]: *** No rule to make target `signing_key.x509', needed by `kernel/x509_certificate_list'.  Stop.
> 
> 
> Full randconfig file is attached.

Works for me.  It's likely that the changes I made on the 18th aren't in the
linux-next tree for the 18th.

David
