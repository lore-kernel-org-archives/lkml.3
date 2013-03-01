Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752406Ab3CAWKM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 17:10:12 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:33758 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112Ab3CAWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 17:10:10 -0500
Date: Fri, 01 Mar 2013 17:10:08 -0500 (EST)
Message-Id: <20130301.171008.1027312383466468118.davem@davemloft.net>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, jslaby@suse.cz
Subject: Re: WARNING at tty_buffer.c:428 process_one_work()
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130301215609.GA3261@kroah.com>
References: <20130301.164711.326215889038834651.davem@davemloft.net>
	<20130301215609.GA3261@kroah.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Fri, 01 Mar 2013 14:10:14 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>
Date: Fri, 1 Mar 2013 13:56:09 -0800

> On Fri, Mar 01, 2013 at 04:47:11PM -0500, David Miller wrote:
>> 
>> I'm getting these non-stop right when the hypervisor console registers
>> on sparc64, and the machine won't boot up properly.  This is with
>> Linus's current tree.
>> 
>> [511865.556835] console [ttyHV0] enabled
>> [511865.564555] ------------[ cut here ]------------
>> [511865.612410] WARNING: at drivers/tty/tty_buffer.c:428 process_one_work+0x164/0x420()
>> [511865.627846] tty is NULL
> 
> Sorry about this, I have a patch, from Jiri, to get to Linus after
> 3.9-rc1 to remove the warning.  It's safe to ignore.  Maybe I should
> just push it today, I wasn't aware that it was being hit so easily.

Ok, next I'm hitting some regression in Al Viro's signal changes when userland
starts up. :-)
