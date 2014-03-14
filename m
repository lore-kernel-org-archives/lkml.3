Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756244AbaCNROr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 13:14:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359AbaCNROp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 13:14:45 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1394729834.8457.58.camel@dhcp-9-2-203-236.watson.ibm.com>
References: <1394729834.8457.58.camel@dhcp-9-2-203-236.watson.ibm.com> <21625.1394725646@warthog.procyon.org.uk>
To: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org,
        dmitry.kasatkin@gmail.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@us.ibm.com>
Subject: Re: RFC: 'ioctl' for keyrings
Date: Fri, 14 Mar 2014 17:14:35 +0000
Message-ID: <7511.1394817275@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:

> > As I understand the code, I think operations being performed from ->update()
> > are:
> > 
> >  (a) Resealing a key with a new pcrs (trusted).
> > 
> >  (b) Changing the master key (encrypted).
> > 
> > Mimi, Dmitry: is this list right?
> 
> In addition to resealing trusted keys to a new TPM PCR value, there are
> a few other options that can be modified (eg. keyauth, blobauth,
> pcrlock).  Encrypted keys can be encrypted/decrypted with a new master
> key (trusted or user key type).

Can (re)sealing a key be viewed as encrypting it?  Is the difference between
sealing a key and encrypting a key the use of hardware support?

David
