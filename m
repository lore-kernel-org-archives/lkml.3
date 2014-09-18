Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755806AbaIRNX5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 09:23:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:10994 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755679AbaIRNX4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 09:23:56 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.11.1409181712020.1998@namei.org>
References: <alpine.LRH.2.11.1409181712020.1998@namei.org> <alpine.LRH.2.11.1409180922540.31048@namei.org> <23655.1410874187@warthog.procyon.org.uk> <24647.1410876063@warthog.procyon.org.uk> <2171.1410996444@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KEYS: Fixes for keyrings
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20015.1411046628.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Thu, 18 Sep 2014 14:23:48 +0100
Message-ID: <20016.1411046628@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > > No, if they go direct to Linus, they don't go into -next.
> > 
> > Can you then sync your -next branch to Linus after Linus takes them please?
> 
> Nope, I only want to sync on point releases unless absolutely necessary.

In that case, can you please just pull the request in this message that I sent
you:

	[GIT PULL] KEYS: Changes for keyrings for security/next

It has the aforementioned fixes and the stuff for -next both.  If you can just
pull the lot into your -next branch rather than sending the fixes upstream at
this point.

David
