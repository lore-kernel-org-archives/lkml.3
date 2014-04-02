Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaDDEuV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 00:50:21 -0400
Received: from ozlabs.org ([203.10.76.45]:49072 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127AbaDDEuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 00:50:18 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stefan Hajnoczi <stefanha@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Venkatesh Srinivas <venkateshs@google.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Linux Virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [PATCH] virtio-blk: make the queue depth the max supportable by the hypervisor
In-Reply-To: <CAJSP0QV_mf9D0t5ozWRRsMO1Wq7OTQ8SiOKh-HrW7buzNQQngQ@mail.gmail.com>
References: <1394841445-16142-1-git-send-email-venkateshs@google.com> <1394854471-25700-1-git-send-email-tytso@mit.edu> <87siqhu048.fsf@rustcorp.com.au> <20140317054053.GF14162@thunk.org> <871txysnw2.fsf@rustcorp.com.au> <CAHdzE-_cAndCNhBM1N0RpjQDhoh3Snas-eza4rYN33Rf69PXyw@mail.gmail.com> <CAHdzE--CvgsPOFQ5OFRoe7L+kkJ0J3eRWR0JQv34i4AmNDBJug@mail.gmail.com> <87ha6fowh9.fsf@rustcorp.com.au> <20140401022708.GD4911@thunk.org> <CAJSP0QV_mf9D0t5ozWRRsMO1Wq7OTQ8SiOKh-HrW7buzNQQngQ@mail.gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Wed, 02 Apr 2014 18:06:08 +1030
Message-ID: <878urop4if.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Hajnoczi <stefanha@gmail.com> writes:
> On Tue, Apr 1, 2014 at 4:27 AM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Mon, Mar 31, 2014 at 02:22:50PM +1030, Rusty Russell wrote:
>>>
>>> It's head of my virtio-next tree.
>>
>> Hey Rusty,
>>
>> While we have your attention --- what's your opinion about adding TRIM
>> support to virtio-blk.  I understand that you're starting an OASIS
>> standardization process for virtio --- what does that mean vis-a-vis a
>> patch to plumb discard support through virtio-blk?
>
> virtio-scsi already supports discard.  But maybe you cannot switch
> away from virtio-blk?
>
> If you need to add discard to virtio-blk then it could be added to the
> standard.  The standards text is kept in a svn repository here:
> https://tools.oasis-open.org/version-control/browse/wsvn/virtio/

It would be trivial to add, and I wouldn't be completely opposed, but we
generally point to virtio-scsi when people want actual features.

Cheers,
Rusty.
