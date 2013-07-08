Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753432Ab3GHCWQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jul 2013 22:22:16 -0400
Received: from ozlabs.org ([203.10.76.45]:46969 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753356Ab3GHCWO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jul 2013 22:22:14 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio: include asm/barrier explicitly
In-Reply-To: <20130707142019.GA2447@redhat.com>
References: <20130707142019.GA2447@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Mon, 08 Jul 2013 11:31:45 +0930
Message-ID: <87obaderna.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> virtio_ring.h uses mb() and friends, make
> it pull in asm/barrier.h itself, not rely
> on other headers to do it.
>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>

Applied.

Thanks,
Rusty.
PS.  I'll squeeze these into this merge window, since they're trivial.
