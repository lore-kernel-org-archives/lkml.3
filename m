Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757706Ab3CDOIB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Mar 2013 09:08:01 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab3CDOIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Mar 2013 09:08:00 -0500
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <1362275632-20242-13-git-send-email-cesarb@cesarb.net>
References: <1362275632-20242-13-git-send-email-cesarb@cesarb.net> <1362275632-20242-1-git-send-email-cesarb@cesarb.net>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: dhowells@redhat.com, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Joe Perches <joe@perches.com>
Subject: Re: [PATCH 12/14] MAINTAINERS: adjust for UAPI (part 2)
Date: Mon, 04 Mar 2013 14:07:50 +0000
Message-ID: <8282.1362406070@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cesar Eduardo Barros <cesarb@cesarb.net> wrote:

>  F:	include/linux/*aio*.h
> +F:	include/uapi/linux/*aio*.h

I wonder if we can infer things like this in the scripts rather than needing
to make it explicit.

David
