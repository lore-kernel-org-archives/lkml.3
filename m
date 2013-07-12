Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753026Ab3GLGCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 02:02:10 -0400
Received: from ozlabs.org ([203.10.76.45]:59545 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751480Ab3GLGCJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 02:02:09 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jason Wang <jasowang@redhat.com>, Cong Wang <amwang@redhat.com>,
        Amos Kong <akong@redhat.com>, Dave Jones <davej@redhat.com>,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, qemu-devel@nongnu.org
Subject: Re: [PATCH] virtio-net: put virtio net header inline with data
In-Reply-To: <20130711130007.GA3794@redhat.com>
References: <20130708101259.GA16074@redhat.com> <871u78eavc.fsf@rustcorp.com.au> <20130711130007.GA3794@redhat.com>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 12 Jul 2013 15:27:18 +0930
Message-ID: <87oba82udd.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> writes:
> On Tue, Jul 09, 2013 at 11:46:23AM +0930, Rusty Russell wrote:
>> "Michael S. Tsirkin" <mst@redhat.com> writes:
>> > For small packets we can simplify xmit processing
>> > by linearizing buffers with the header:
>> > most packets seem to have enough head room
>> > we can use for this purpose.
>> > Since existing hypervisors require that header
>> > is the first s/g element, we need a feature bit
>> > for this.
>> >
>> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> > ---
>> >
>> > Note: this needs to be applied on top of patch
>> > defining VIRTIO_F_ANY_LAYOUT - bit to be
>> > selected by Rusty.
>> >
>> > The following patch should work for any definition of
>> > VIRTIO_F_ANY_LAYOUT - I used bit 31 for testing.
>> > Rusty, could you please pick a valid bit for VIRTIO_F_ANY_LAYOUT
>> > and squeeze this patch into 3.11?
>> 
>> Sorry, it's too late.
>> 
>> First, I've been a bit lax in sending patches via DaveM, and this is
>> definitely his territory (ie. more net than virtio).
>> 
>> Secondly, it needs baking and testing time.
>> 
>> Cheers,
>> Rusty.
>
> Okay. But we can already commit the qemu change, right?
> Also, can you submit the spec update please?

The spec has been updated, BTW.

Cheers,
Rusty.
