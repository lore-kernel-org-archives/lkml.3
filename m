Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752762AbaG1PhV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:37:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752247AbaG1PhR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:37:17 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <14383.1406559660@warthog.procyon.org.uk>
References: <14383.1406559660@warthog.procyon.org.uk> <53D662E9.5050409@oracle.com> <53D31D16.1030806@oracle.com> <26466.1406547132@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, Sasha Levin <sasha.levin@oracle.com>,
        Andrey Ryabinin <a.ryabinin@samsung.com>,
        James Morris <james.l.morris@oracle.com>, serge@hallyn.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: security: oops on boot in __key_link_begin
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3111.1406561822.1@warthog.procyon.org.uk>
Date: Mon, 28 Jul 2014 16:37:02 +0100
Message-ID: <3112.1406561822@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Sasha Levin <sasha.levin@oracle.com> wrote:
> 
> > I've tried keys-next and linux-next for today and it didn't reproduce, but
> > it did show up again when I applied the KASAN patchset (Cc Andrey).
> 
> The 'KASAN' patchset?

Never mind.  I should've googled first.

David
