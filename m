Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab3JIROQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Oct 2013 13:14:16 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:49516 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab3JIROO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Oct 2013 13:14:14 -0400
Date: Wed, 09 Oct 2013 13:14:10 -0400 (EDT)
Message-Id: <20131009.131410.227391605999363505.davem@davemloft.net>
To: mst@redhat.com
Cc: jasowang@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        edumazet@google.com, xemul@parallels.com
Subject: Re: [PATCH] tun: don't look at current when non-blocking
From: David Miller <davem@davemloft.net>
In-Reply-To: <20131009081354.GA30882@redhat.com>
References: <20131008.154614.1435858706789904414.davem@davemloft.net>
	<5254F6CF.8080606@redhat.com>
	<20131009081354.GA30882@redhat.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 09 Oct 2013 10:14:14 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Michael S. Tsirkin" <mst@redhat.com>
Date: Wed, 9 Oct 2013 11:13:54 +0300

> On Wed, Oct 09, 2013 at 02:25:19PM +0800, Jason Wang wrote:
>> On 10/09/2013 03:46 AM, David Miller wrote:
>> > From: "Michael S. Tsirkin" <mst@redhat.com>
>> > Date: Sun, 6 Oct 2013 21:25:12 +0300
>> >
>> >> We play with a wait queue even if socket is
>> >> non blocking. This is an obvious waste.
>> >> Besides, it will prevent calling the non blocking
>> >> variant when current is not valid.
>> >>
>> >> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
>> > Applied and queued up for -stable, thanks.
>> > --
>> 
>> Michael, I believe this is just an optimization or a required patch of
>> your following patches. So no need go for stable?
> 
> I don't think it's required for stable.

Ok, removed from the -stable queue.  Thanks.
