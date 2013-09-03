Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933749Ab3ICTIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 15:08:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37844 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933318Ab3ICTIn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 15:08:43 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1308301120310.9639@tundra.namei.org>
References: <alpine.LRH.2.02.1308301120310.9639@tundra.namei.org> <alpine.LRH.2.02.1308291144090.431@tundra.namei.org> <11520.1377735648@warthog.procyon.org.uk> <21592.1377799564@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, simo@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Expand keyring capacity and provide support for libkrb5
Date: Tue, 03 Sep 2013 20:08:38 +0100
Message-ID: <6914.1378235318@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > Ummm...  Where did that come from?  That doesn't look like what's in my
> > tree...
> 
> Is your tree based on mine?

It is now.  See:

	http://git.kernel.org/cgit/linux/kernel/git/dhowells/linux-fs.git/log/?h=keys-devel

based on your "next" branch.  If you can take up to the keys-krb-support tag
for now?

David
