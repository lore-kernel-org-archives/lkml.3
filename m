Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758001Ab3BGERd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:17:33 -0500
Received: from ozlabs.org ([203.10.76.45]:51884 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756686Ab3BGERX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:17:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Joe Perches <joe@perches.com>, netdev@vger.kernel.org
Cc: Joerg Reuter <jreuter@yaina.de>, "Michael S. Tsirkin" <mst@redhat.com>,
        linux-hams@vger.kernel.org, linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 8/8] drivers:net:misc: Remove unnecessary alloc/OOM messages
In-Reply-To: <a729555c8acf2cc3ef4c80531757b37a948c4e55.1359939013.git.joe@perches.com>
References: <cover.1359939012.git.joe@perches.com> <a729555c8acf2cc3ef4c80531757b37a948c4e55.1359939013.git.joe@perches.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 07 Feb 2013 14:38:52 +1030
Message-ID: <87lib0ix4b.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches <joe@perches.com> writes:

> alloc failures already get standardized OOM
> messages and a dump_stack.
>
> Signed-off-by: Joe Perches <joe@perches.com>

Why not, less code is always good.

Acked-by: Rusty Russell <rusty@rustcorp.com.au> (virtio_net)

Cheers,
Rusty.
