Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751654Ab3GQFFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jul 2013 01:05:31 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44170 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751360Ab3GQFFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jul 2013 01:05:30 -0400
Date: Tue, 16 Jul 2013 22:05:29 -0700 (PDT)
Message-Id: <20130716.220529.49723311269417873.davem@davemloft.net>
To: mst@redhat.com
Cc: rusty@rustcorp.com.au, netdev@vger.kernel.org, jasowang@redhat.com,
        amwang@redhat.com, akong@redhat.com, davej@redhat.com,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-net: put virtio net header inline with data
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130717050032.GB10482@redhat.com>
References: <8761wc38ea.fsf@rustcorp.com.au>
	<20130716.123326.798365002638711260.davem@davemloft.net>
	<20130717050032.GB10482@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Tue, 16 Jul 2013 22:05:30 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 17 Jul 2013 08:00:32 +0300

> On Tue, Jul 16, 2013 at 12:33:26PM -0700, David Miller wrote:
>> From: Rusty Russell <rusty@rustcorp.com.au>
>> Date: Mon, 15 Jul 2013 11:13:25 +0930
>> 
>> > From: Michael S. Tsirkin <mst@redhat.com>
>> > 
>> > For small packets we can simplify xmit processing
>> > by linearizing buffers with the header:
>> > most packets seem to have enough head room
>> > we can use for this purpose.
>> > Since existing hypervisors require that header
>> > is the first s/g element, we need a feature bit
>> > for this.
>> > 
>> > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
>> 
>> I really think this has to wait until the next merge window, sorry.
>> 
>> Please resubmit this when I open net-next back up, thanks.
> 
> I assumed since -rc1 is out net-next is already open?

-rc1 being released never makes net-next open.  Instead, I explicitly
open it up at some point in time after -rc1 when I feel that things
have settled down enough.

And when that happens, I announce so here.

So you have to follow my announcements here on netdev to know
when net-next is actually open.
