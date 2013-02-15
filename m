Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935288Ab3BOEDA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 23:03:00 -0500
Received: from ozlabs.org ([203.10.76.45]:56868 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932324Ab3BOEC7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 23:02:59 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Pawel Moll <pawel.moll@arm.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, Marc Zyngier <Marc.Zyngier@arm.com>,
        linux-kernel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH] virtio-spec: Define virtio-mmio registers as LE
In-Reply-To: <1360839247-9131-1-git-send-email-pawel.moll@arm.com>
References: <87wqubkalj.fsf@rustcorp.com.au> <1360839247-9131-1-git-send-email-pawel.moll@arm.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 15 Feb 2013 14:27:47 +1030
Message-ID: <87ehgijkjo.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pawel Moll <pawel.moll@arm.com> writes:
> To solve the never-ending confusions between hosts and guests
> of different endianess, define all virtio-mmio registers as LE.
>
> This change should be safe at this stage, because no known
> working mixed-endian system exists so there is virtually no
> risk of breaking compatibility.
>
> Signed-off-by: Pawel Moll <pawel.moll@arm.com>

Applied.  We could also move device configuration space to LE, if we
wanted.  It's a bigger change to the Linux implementation, since we now
need accessors for each width, but it might be a good idea.  OTOH,
getting such a change into qemu might be harder...

Cheers,
Rusty.
