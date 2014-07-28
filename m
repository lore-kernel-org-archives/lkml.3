Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753052AbaG1PBW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 11:01:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752616AbaG1PBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 11:01:20 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53D662E9.5050409@oracle.com>
References: <53D662E9.5050409@oracle.com> <53D31D16.1030806@oracle.com> <26466.1406547132@warthog.procyon.org.uk>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: dhowells@redhat.com, Andrey Ryabinin <a.ryabinin@samsung.com>,
        James Morris <james.l.morris@oracle.com>, serge@hallyn.com,
        keyrings@linux-nfs.org, linux-security-module@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: security: oops on boot in __key_link_begin
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <14382.1406559660.1@warthog.procyon.org.uk>
Date: Mon, 28 Jul 2014 16:01:00 +0100
Message-ID: <14383.1406559660@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sasha Levin <sasha.levin@oracle.com> wrote:

> I've tried keys-next and linux-next for today and it didn't reproduce, but
> it did show up again when I applied the KASAN patchset (Cc Andrey).

The 'KASAN' patchset?

David
