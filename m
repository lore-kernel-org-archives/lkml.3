Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932219AbaFZAoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 20:44:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39653 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756330AbaFZAoy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 20:44:54 -0400
Date: Wed, 25 Jun 2014 17:44:52 -0700 (PDT)
Message-Id: <20140625.174452.216399345748954052.davem@davemloft.net>
To: cwang@twopensource.com
Cc: zoltan.kiss@citrix.com, steffen.klassert@secunet.com,
        minipli@googlemail.com, dborkman@redhat.com, tgraf@suug.ch,
        joe@perches.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xen-devel@lists.xenproject.org
Subject: Re: [PATCH net-next 3/3 RFC] pktgen: Allow sending TCP packets
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAHA+R7NR4PmLbwmKXL8iwdwm3STNmpT4iZCp3VgB2zAqWZm7XQ@mail.gmail.com>
References: <1403728972-29548-1-git-send-email-zoltan.kiss@citrix.com>
	<1403728972-29548-4-git-send-email-zoltan.kiss@citrix.com>
	<CAHA+R7NR4PmLbwmKXL8iwdwm3STNmpT4iZCp3VgB2zAqWZm7XQ@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 25 Jun 2014 17:44:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <cwang@twopensource.com>
Date: Wed, 25 Jun 2014 17:41:47 -0700

> On Wed, Jun 25, 2014 at 1:42 PM, Zoltan Kiss <zoltan.kiss@citrix.com> wrote:
>> This is a prototype patch to enable sending TCP packets with pktgen. The
>> original motivation is to test TCP GSO with xen-netback/netfront, but I'm not
>> sure about how the checksum should be set up, and also someone should verify the
>> GSO settings I'm using.
>>
> 
> What's the point of sending TCP packets since you don't establish a TCP
> connection?

I guess they want to test checksumming and aggregation, things like that.

The other side is of course going to spew reset packets back at the
pktgen machine.
