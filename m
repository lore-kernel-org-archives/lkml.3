Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754037AbaG2PcP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 11:32:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64383 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753327AbaG2PcO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 11:32:14 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53CE885C.4070302@adfin.com>
References: <53CE885C.4070302@adfin.com> <cover.1406043029.git.milosz@adfin.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        "NeilBrown" <neilb@suse.de>, "Shantanu Goel" <sgoel01@yahoo.com>
Subject: Re: [PATCH 1/3] FS-Cache: Timeout for releasepage()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <28562.1406647922.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: 8BIT
Date: Tue, 29 Jul 2014 16:32:02 +0100
Message-ID: <28563.1406647922@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> +bool relase_page_wait_timeout(struct fscache_cookie *cookie, struct page *page

I presume you mean "release_page_wait_timeout".

Also, the new function returns a value which you then ignore.  Should you do
something with it?

David
