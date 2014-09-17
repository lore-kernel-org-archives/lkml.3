Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757191AbaIQViE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 17:38:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2855 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757137AbaIQViC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 17:38:02 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <27834.1410966793@warthog.procyon.org.uk>
References: <27834.1410966793@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, torvalds@linux-foundation.org, milosz@adfin.com,
        neilb@suse.de, linux-cachefs@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Fixes for FS-Cache/CacheFiles
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <6546.1410989868.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 17 Sep 2014 22:37:48 +0100
Message-ID: <6547.1410989868@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> Could you pull these fixes for FS-Cache and Cachefiles:
> 
>  (1) Put a timeout in releasepage() to deal with a recursive hang between the
>      memory allocator, writeback, ext4 and fscache under memory pressure.
> 
>  (2) Fix a pair of refcount bugs in the fscache error handling.
> 
>  (3) Remove a couple of unused pagevecs.  This could be punted to -next if
>      you'd rather.

Please don't pull them just at the moment.  I've spotted a bug in one of them.

David
