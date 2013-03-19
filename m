Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933923Ab3CSUaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:30:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:48069 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754739Ab3CSUaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:30:22 -0400
Date: Tue, 19 Mar 2013 16:30:21 -0400 (EDT)
Message-Id: <20130319.163021.554696658570846637.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: sam@ravnborg.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: remove unused "config BITS"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363724768.1390.36.camel@x61.thuisdomein>
References: <1363712807.1390.26.camel@x61.thuisdomein>
	<20130319201454.GA25072@merkur.ravnborg.org>
	<1363724768.1390.36.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Mar 2013 13:30:26 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 19 Mar 2013 21:26:08 +0100

> On Tue, 2013-03-19 at 21:14 +0100, Sam Ravnborg wrote:
>> On Tue, Mar 19, 2013 at 06:06:47PM +0100, Paul Bolle wrote:
>> > So $(BITS) is set depending on whether CONFIG_SPARC32 is set or not.
>> > Using $(BITS) in sparc's Makefiles is not using CONFIG_BITS. That
>> > doesn't count as usage of "config BITS". 
>> Just double checked - you are right.
> 
> Thanks.
> 
>> Maybe send a v2 with this info in changelog and add my:
>> 
>> Acked-by: Sam Ravnborg <sam@ravnborg.org>
> 
> David: should I send a second version with a line or two on the
> (non-related) use of BITS in the Makefiles and Sam's ACK?

Like I replied to Sam, no need, I took care of this.
