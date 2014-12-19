Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751847AbaLSBjH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Dec 2014 20:39:07 -0500
Received: from ozlabs.org ([103.22.144.67]:55264 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751224AbaLSBiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Dec 2014 20:38:50 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] fix up vringh/mic sparse errors
In-Reply-To: <1418678019-31629-1-git-send-email-mst@redhat.com>
References: <1418678019-31629-1-git-send-email-mst@redhat.com>
User-Agent: Notmuch/0.17 (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Fri, 19 Dec 2014 11:57:22 +1030
Message-ID: <87r3vwsa2t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> This fixes remaining sparse warnings in vringh and mic by using
> virtio 1.0 compliant wrappers.
>
> This also needs by get_user patches to avoid getting warnings
> from these calls.
>
> Tested by running vringh_test.
>
> Rusty, I prefer fixing all these warnings for 3.19, any objections?

OK, I've queued these too.

Cheers,
Rusty.

> Michael S. Tsirkin (3):
>   vringh: 64 bit features
>   vringh: initial virtio 1.0 support
>   mic/host: initial virtio 1.0 support
>
>  include/linux/vringh.h              |  37 ++++++++++-
>  drivers/misc/mic/host/mic_debugfs.c |  18 ++++--
>  drivers/vhost/vringh.c              | 125 ++++++++++++++++++++++--------------
>  3 files changed, 123 insertions(+), 57 deletions(-)
>
> -- 
> MST
