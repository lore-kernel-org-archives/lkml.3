Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752162AbaCSRsr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2014 13:48:47 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:58485 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaCSRsp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2014 13:48:45 -0400
MIME-Version: 1.0
In-Reply-To: <871txysnw2.fsf@rustcorp.com.au>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com>
	<1394854471-25700-1-git-send-email-tytso@mit.edu>
	<87siqhu048.fsf@rustcorp.com.au>
	<20140317054053.GF14162@thunk.org>
	<871txysnw2.fsf@rustcorp.com.au>
Date: Wed, 19 Mar 2014 10:48:44 -0700
Message-ID: <CAHdzE-_cAndCNhBM1N0RpjQDhoh3Snas-eza4rYN33Rf69PXyw@mail.gmail.com>
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by
 the hypervisor
From: Venkatesh Srinivas <venkateshs@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: tytso@mit.edu, Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>, virtio-dev@lists.oasis-open.org,
        virtualization@lists.linux-foundation.org,
        Frank Swiderski <fes@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And I rewrote it substantially, mainly to take
> VIRTIO_RING_F_INDIRECT_DESC into account.
>
> As QEMU sets the vq size for PCI to 128, Venkatash's patch wouldn't
> have made a change.  This version does (since QEMU also offers
> VIRTIO_RING_F_INDIRECT_DESC.

That divide-by-2 produced the same queue depth as the prior
computation in QEMU was deliberate -- but raising it to 128 seems
pretty reasonable.

Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>

-- vs;
