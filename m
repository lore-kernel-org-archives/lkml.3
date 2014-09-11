Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754776AbaIKMKB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:10:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60062 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754499AbaIKMKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:10:00 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1410435813.5187.36.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1410435813.5187.36.camel@dhcp-9-2-203-236.watson.ibm.com> <20140910212154.10752.23343.stgit@warthog.procyon.org.uk> <20140910212206.10752.21818.stgit@warthog.procyon.org.uk> <1410392204.5187.14.camel@dhcp-9-2-203-236.watson.ibm.com>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, jmorris@namei.org, keyrings@linux-nfs.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 2/6] KEYS: Reinstate EPERM for a key type name beginning with a '.'
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <27731.1410437386.1@warthog.procyon.org.uk>
Date: Thu, 11 Sep 2014 13:09:46 +0100
Message-ID: <27732.1410437386@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> On Wed, 2014-09-10 at 19:36 -0400, Mimi Zohar wrote: 
> > On Wed, 2014-09-10 at 22:22 +0100, David Howells wrote: 
> > > Reinstate the generation of EPERM for a key type name beginning with a
> > > '.' in a userspace call.  Types whose name begins with a '.' are
> > > internal only.
> 
> After re-reading your comment and looking at the different types,
> testing for dot prefixed types now makes sense.  Both dot prefixed types
> and keyring names are reserved for the kernel.

Are you withdrawing your objection, then?

David
