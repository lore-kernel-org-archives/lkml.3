Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab3G1Ejq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Jul 2013 00:39:46 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:52692 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751730Ab3G1Ejo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Jul 2013 00:39:44 -0400
Date: Sat, 27 Jul 2013 21:39:43 -0700 (PDT)
Message-Id: <20130727.213943.1973842777687951434.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: ben@decadent.org.uk, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [ 06/79] net: Swap ver and type in pppoe_hdr
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130728041616.GA32761@kroah.com>
References: <20130727.175541.1879192128080680197.davem@davemloft.net>
	<1374981271.2476.0.camel@deadeye.wl.decadent.org.uk>
	<20130728041616.GA32761@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 27 Jul 2013 21:39:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Sat, 27 Jul 2013 21:16:16 -0700

> On Sun, Jul 28, 2013 at 04:14:31AM +0100, Ben Hutchings wrote:
>> On Sat, 2013-07-27 at 17:55 -0700, David Miller wrote:
>> > From: Ben Hutchings <ben@decadent.org.uk>
>> > Date: Sat, 27 Jul 2013 16:58:28 +0100
>> > 
>> > > I'm not so sure this is suitable for stable.  It doesn't seem to be
>> > > helpful to either userland or kernel code.
>> > > 
>> > > In the kernel, we were checking that ver == 1 and type == 1 thus this
>> > > wasn't hurting us.
>> > > 
>> > > If userland does anything more with these fields then it's probably
>> > > already working around the swapped fields.  It can work with both old
>> > > and new headers by doing:
>> > 
>> > It's up to you, I would rather have the corrected version propagated
>> > as soon as possible.  But that's just me.
>> 
>> Let's see what Greg thinks.
> 
> I'm guessing that Linus's tree is also "wrong" here, correct?  If so,
> the fix that goes into that tree should also go here as well.
> 
> Or am I confused?

Linus's tree has had this change for a full release.  It went into
3.10

It's correcting a mistake that has been there since the header
file even existed.

