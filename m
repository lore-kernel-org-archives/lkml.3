Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934935AbaH0O3M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:29:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54087 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934508AbaH0O3K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:29:10 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53EB9928.1030601@adfin.com>
References: <53EB9928.1030601@adfin.com> <cover.1407948737.git.milosz@adfin.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/3] FS-Cache: Timeout for releasepage()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32459.1409149741.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Wed, 27 Aug 2014 15:29:01 +0100
Message-ID: <32460.1409149741@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> + * since we might be called recusively via parent fs.

I've changed that to "recursively".

> +bool relase_page_wait_timeout(struct fscache_cookie *cookie, struct page *page)

I've changed that to "release_page_wait_timeout()".

> +	if (!relase_page_wait_timeout(cookie, page)) {
> +		_debug("fscache writeout timeout page: %p{%lx}",
> +			page, page->index);
> +	}

And I've dropped the braces there.

David
