Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752144Ab3LBO27 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 09:28:59 -0500
Received: from mail-qe0-f50.google.com ([209.85.128.50]:40948 "EHLO
	mail-qe0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751961Ab3LBO2m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 09:28:42 -0500
MIME-Version: 1.0
In-Reply-To: <20131130175903.GL24171@order.stressinduktion.org>
References: <20131128190411.GD24171@order.stressinduktion.org>
	<20131129.163930.203685593163996122.davem@davemloft.net>
	<20131130174635.GK24171@order.stressinduktion.org>
	<20131130.125110.248139896351909341.davem@davemloft.net>
	<20131130175903.GL24171@order.stressinduktion.org>
Date: Mon, 2 Dec 2013 19:58:41 +0530
Message-ID: <CAP8BHkHqNbyEjTUZiKdJ+qz7USGy39t-15b55VfzCu88rnZpjQ@mail.gmail.com>
Subject: Re: [PATCH] ipv6: ip6_pkt_prohibit(_out) should not depend on CONFIG_IPV6_MULTIPLE_TABLES
From: Kamala R <kamala@aristanetworks.com>
To: David Miller <davem@davemloft.net>, Kamala R <kamala@aristanetworks.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Frederic Sowa <hannes@stressinduktion.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I have submitted a version 4 of my patch that squashes the above
changes into it as well. Is that the right way to do it ?

Regards,
Kamala

On Sat, Nov 30, 2013 at 11:29 PM, Hannes Frederic Sowa
<hannes@stressinduktion.org> wrote:
> On Sat, Nov 30, 2013 at 12:51:10PM -0500, David Miller wrote:
>> From: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> Date: Sat, 30 Nov 2013 18:46:35 +0100
>>
>> > On Fri, Nov 29, 2013 at 04:39:30PM -0500, David Miller wrote:
>> >> From: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> >> Date: Thu, 28 Nov 2013 20:04:11 +0100
>> >>
>> >> > Since patch "IPv6: Fixed support for blackhole and prohibit routes" we
>> >> > need ip6_pkt_prohibit(_out) available without CONFIG_IPV6_MULTIPLE_TABLES
>> >> > defined.
>> >> >
>> >> > Cc: Kamala R <kamala@aristanetworks.com>
>> >> > Signed-off-by: Hannes Frederic Sowa <hannes@stressinduktion.org>
>> >>
>> >> Please reference the SHA1 ID of the change as well as it's commit
>> >> header text, thank you.
>> >
>> > This patch is a follow-up patch for the first one in this thread which is not
>> > committed, yet. Either Kamala can squash them into one or I'll repost it
>> > later.
>>
>> I think they need to be combined, otherwise bisection is broken.
>
> Kamala, as your patch is the main one, can you squash my patch into yours?
>
