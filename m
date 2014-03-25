Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754337AbaCYSu6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 14:50:58 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61357 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753371AbaCYSu4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 14:50:56 -0400
MIME-Version: 1.0
In-Reply-To: <CAHdzE-_cAndCNhBM1N0RpjQDhoh3Snas-eza4rYN33Rf69PXyw@mail.gmail.com>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com>
	<1394854471-25700-1-git-send-email-tytso@mit.edu>
	<87siqhu048.fsf@rustcorp.com.au>
	<20140317054053.GF14162@thunk.org>
	<871txysnw2.fsf@rustcorp.com.au>
	<CAHdzE-_cAndCNhBM1N0RpjQDhoh3Snas-eza4rYN33Rf69PXyw@mail.gmail.com>
Date: Tue, 25 Mar 2014 11:50:55 -0700
Message-ID: <CAHdzE--CvgsPOFQ5OFRoe7L+kkJ0J3eRWR0JQv34i4AmNDBJug@mail.gmail.com>
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by
 the hypervisor
From: Venkatesh Srinivas <venkateshs@google.com>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 19, 2014 at 10:48 AM, Venkatesh Srinivas
<venkateshs@google.com> wrote:
>> And I rewrote it substantially, mainly to take
>> VIRTIO_RING_F_INDIRECT_DESC into account.
>>
>> As QEMU sets the vq size for PCI to 128, Venkatash's patch wouldn't
>> have made a change.  This version does (since QEMU also offers
>> VIRTIO_RING_F_INDIRECT_DESC.
>
> That divide-by-2 produced the same queue depth as the prior
> computation in QEMU was deliberate -- but raising it to 128 seems
> pretty reasonable.
>
> Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>

Soft ping about this patch.

Thanks,
-- vs;
