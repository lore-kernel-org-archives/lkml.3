Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751532Ab3JRGbr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 02:31:47 -0400
Received: from ozlabs.org ([203.10.76.45]:43464 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751421Ab3JRGbp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 02:31:45 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: David Miller <davem@davemloft.net>
Cc: mst@redhat.com, jasowang@redhat.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, gaowanlong@cn.fujitsu.com,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH net V2 1/2] virtio-net: don't respond to cpu hotplug notifier if we're not ready
In-Reply-To: <20131017.234816.1960399038382112445.davem@davemloft.net>
References: <8738o0aj9u.fsf@rustcorp.com.au> <20131017050710.GA12141@redhat.com> <87d2n3s89s.fsf@rustcorp.com.au> <20131017.234816.1960399038382112445.davem@davemloft.net>
User-Agent: Notmuch/0.15.2+81~gd2c8818 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Fri, 18 Oct 2013 16:47:14 +1030
Message-ID: <87iowvje6t.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Miller <davem@davemloft.net> writes:
> From: Rusty Russell <rusty@rustcorp.com.au>
> Date: Fri, 18 Oct 2013 11:30:15 +1030
>
>> Asking people to express 'CC: stable' in words is error-prone; if Dave
>> wants to filter it, he's quite capable.
>
> Filtering it one time is one thing.
>
> Potentially acting on that filter 100 or so times a day...
>
> That's completely another.

I don't see the difference between reacting to:

> The patch were need for 3.10 and above.

And:

CC: stable@kernel.org # 3.10+

Except the latter is the standard form which everyone else uses.

Do you want awk script to turn the latter into the former?  Would that
really help?

Confused,
Rusty.
