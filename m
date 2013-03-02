Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab3CBGfI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 01:35:08 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:38458 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3CBGfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 01:35:07 -0500
Date: Sat, 02 Mar 2013 01:35:03 -0500 (EST)
Message-Id: <20130302.013503.480791737320702176.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: sfr@canb.auug.org.au, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, jslaby@suse.cz
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130302052330.GV4503@ZenIV.linux.org.uk>
References: <20130301.171008.1027312383466468118.davem@davemloft.net>
	<20130302154935.b5695346222e75562c0327e0@canb.auug.org.au>
	<20130302052330.GV4503@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 01 Mar 2013 22:35:10 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Sat, 2 Mar 2013 05:23:30 +0000

> On Sat, Mar 02, 2013 at 03:49:35PM +1100, Stephen Rothwell wrote:
>> On Fri, 01 Mar 2013 17:10:08 -0500 (EST) David Miller <davem@davemloft.net> wrote:
> 
>> > Ok, next I'm hitting some regression in Al Viro's signal changes when userland
>> > starts up. :-)
>> 
>> If only we had some way of testing this stuff before it gets into Linus'
>> tree ... ;-)
> 
> Dave, my deep apologies.  I only now realized that you hadn't been on Cc of
> the discussion of that crap; see signal.git#for-linus (commit aee41fe) for
> fix...  I thought I'd Cc'd you back then (about a week ago) ;-/

No apology necessary.
