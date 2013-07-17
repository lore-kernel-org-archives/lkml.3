Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab3GQBDr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 21:03:47 -0400
Received: from ozlabs.org ([203.10.76.45]:59745 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750820Ab3GQBDo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 21:03:44 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, netdev@vger.kernel.org, jasowang@redhat.com,
        amwang@redhat.com, akong@redhat.com, davej@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-net: put virtio net header inline with data
In-Reply-To: <20130716.123326.798365002638711260.davem@davemloft.net>
References: <87vc4kcfzg.fsf@rustcorp.com.au> <20130709.213807.350021632586146971.davem@davemloft.net> <8761wc38ea.fsf@rustcorp.com.au> <20130716.123326.798365002638711260.davem@davemloft.net>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Wed, 17 Jul 2013 09:38:15 +0930
Message-ID: <87bo62yro0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Mon, 15 Jul 2013 11:13:25 +0930
>
>> From: Michael S. Tsirkin <mst@redhat.com>
>> 
>> For small packets we can simplify xmit processing
>> by linearizing buffers with the header:
>> most packets seem to have enough head room
>> we can use for this purpose.
>> Since existing hypervisors require that header
>> is the first s/g element, we need a feature bit
>> for this.
>> 
>> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>
> I really think this has to wait until the next merge window, sorry.
>
> Please resubmit this when I open net-next back up, thanks.

Oh, assumed it was already open.    Will re-submit then.

Cheers,
Rusty.
