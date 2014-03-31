Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077AbaCaPy3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 11:54:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26882 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752640AbaCaPy1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 11:54:27 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <alpine.LRH.2.02.1404010231260.16115@tundra.namei.org>
References: <alpine.LRH.2.02.1404010231260.16115@tundra.namei.org> <8321.1396272505@warthog.procyon.org.uk>
To: James Morris <jmorris@namei.org>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, d.kasatkin@samsung.com,
        casey@schaufler-ca.com, keyrings@linux-nfs.org,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] KEYS: Make perm request flags available to security modules
Date: Mon, 31 Mar 2014 16:54:14 +0100
Message-ID: <11268.1396281254@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris <jmorris@namei.org> wrote:

> > Can you pull this pair of patches please?  They move the flags that are
> > used to request specific permissions to a more public header file so that
> > they can then be used by Smack (and other security modules).
> 
> These should be going via my tree.

Okay, if you could pull them then.  I thought Linus wanted keyrings stuff to
go separately.

David
