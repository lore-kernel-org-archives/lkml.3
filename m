Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab3G1Azo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Jul 2013 20:55:44 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51022 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752870Ab3G1Azm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Jul 2013 20:55:42 -0400
Date: Sat, 27 Jul 2013 17:55:41 -0700 (PDT)
Message-Id: <20130727.175541.1879192128080680197.davem@davemloft.net>
To: ben@decadent.org.uk
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [ 06/79] net: Swap ver and type in pppoe_hdr
From: David Miller <davem@davemloft.net>
In-Reply-To: <1374940708.13555.37.camel@deadeye.wl.decadent.org.uk>
References: <20130726204721.849052763@linuxfoundation.org>
	<20130726204722.608161811@linuxfoundation.org>
	<1374940708.13555.37.camel@deadeye.wl.decadent.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 27 Jul 2013 17:55:42 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Hutchings <ben@decadent.org.uk>
Date: Sat, 27 Jul 2013 16:58:28 +0100

> I'm not so sure this is suitable for stable.  It doesn't seem to be
> helpful to either userland or kernel code.
> 
> In the kernel, we were checking that ver == 1 and type == 1 thus this
> wasn't hurting us.
> 
> If userland does anything more with these fields then it's probably
> already working around the swapped fields.  It can work with both old
> and new headers by doing:

It's up to you, I would rather have the corrected version propagated
as soon as possible.  But that's just me.
