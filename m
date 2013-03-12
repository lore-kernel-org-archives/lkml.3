Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab3CLNnM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 09:43:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52021 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753694Ab3CLNnK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 09:43:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20130311141032.7c0fa60279fa172b72fc0bf7@linux-foundation.org>
References: <20130311141032.7c0fa60279fa172b72fc0bf7@linux-foundation.org> <20130306222412.1255.81929.stgit@warthog.procyon.org.uk> <alpine.LRH.2.02.1303071558030.25164@tundra.namei.org> <20130311210211.GA13575@kroah.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, Greg KH <gregkh@linuxfoundation.org>,
        James Morris <jmorris@namei.org>, torvalds@linux-foundation.org,
        keyrings@linux-nfs.org, pmatouse@redhat.com, security@kernel.org,
        linux-kernel@vger.kernel.org, mguzik@redhat.com, ben@decadent.org.uk
Subject: Re: [PATCH] KEYS: Fix race with concurrent install_user_keyrings()
Date: Tue, 12 Mar 2013 13:42:56 +0000
Message-ID: <10968.1363095776@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> James has acked it.  I have it queued for processing so it isn't lost. 
> It has no cc:stable's in it, but David always forgets that ;)

Hmmm...  I did try and resend it there on the 7th.  My mail client records
that it did so, but I don't see it in the list archive and I didn't get any
bounce notifications:-/

David
