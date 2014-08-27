Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935013AbaH0Obt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 10:31:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933802AbaH0Obs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 10:31:48 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <53EB992D.6040608@adfin.com>
References: <53EB992D.6040608@adfin.com> <cover.1407948737.git.milosz@adfin.com>
To: Milosz Tanski <milosz@adfin.com>
Cc: dhowells@redhat.com, linux-cachefs@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 2/3] FS-Cache: Reduce cookie ref count if submit fails.
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <32704.1409149899.1@warthog.procyon.org.uk>
Date: Wed, 27 Aug 2014 15:31:39 +0100
Message-ID: <32705.1409149899@warthog.procyon.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Milosz Tanski <milosz@adfin.com> wrote:

> +	if (__fscache_unuse_cookie(cookie))
> +		__fscache_wake_unused_cookie(cookie);

I've replaced these two lines with "fscache_unuse_cookie(cookie);" as
NeilBrown suggested.

David
