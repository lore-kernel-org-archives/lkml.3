Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289AbaCaEfZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 00:35:25 -0400
Received: from ozlabs.org ([203.10.76.45]:47496 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751542AbaCaEfX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 00:35:23 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Venkatesh Srinivas <venkateshs@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by the hypervisor
In-Reply-To: <CAHdzE--CvgsPOFQ5OFRoe7L+kkJ0J3eRWR0JQv34i4AmNDBJug@mail.gmail.com>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com> <1394854471-25700-1-git-send-email-tytso@mit.edu> <87siqhu048.fsf@rustcorp.com.au> <20140317054053.GF14162@thunk.org> <871txysnw2.fsf@rustcorp.com.au> <CAHdzE-_cAndCNhBM1N0RpjQDhoh3Snas-eza4rYN33Rf69PXyw@mail.gmail.com> <CAHdzE--CvgsPOFQ5OFRoe7L+kkJ0J3eRWR0JQv34i4AmNDBJug@mail.gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Mon, 31 Mar 2014 14:22:50 +1030
Message-ID: <87ha6fowh9.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Venkatesh Srinivas <venkateshs@google.com> writes:
> On Wed, Mar 19, 2014 at 10:48 AM, Venkatesh Srinivas
> <venkateshs@google.com> wrote:
>>> And I rewrote it substantially, mainly to take
>>> VIRTIO_RING_F_INDIRECT_DESC into account.
>>>
>>> As QEMU sets the vq size for PCI to 128, Venkatash's patch wouldn't
>>> have made a change.  This version does (since QEMU also offers
>>> VIRTIO_RING_F_INDIRECT_DESC.
>>
>> That divide-by-2 produced the same queue depth as the prior
>> computation in QEMU was deliberate -- but raising it to 128 seems
>> pretty reasonable.
>>
>> Signed-off-by: Venkatesh Srinivas <venkateshs@google.com>
>
> Soft ping about this patch.

It's head of my virtio-next tree.

Cheers,
Rusty.
