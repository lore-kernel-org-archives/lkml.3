Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932846Ab3CLPdW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 11:33:22 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:54006 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932095Ab3CLPdU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 11:33:20 -0400
Date: Tue, 12 Mar 2013 11:33:28 -0400 (EDT)
Message-Id: <20130312.113328.1340895896039295892.davem@davemloft.net>
To: linux@arm.linux.org.uk
Cc: gang.chen@asianux.com, mgherzan@gmail.com, nschichan@freebox.fr,
        daniel.borkmann@tik.ee.ethz.ch, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM:net: an issue for k which is u32, never < 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <20130311164741.GL4977@n2100.arm.linux.org.uk>
References: <513BECDA.3030803@asianux.com>
	<20130310.171238.330349067962026661.davem@davemloft.net>
	<20130311164741.GL4977@n2100.arm.linux.org.uk>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 12 Mar 2013 08:33:24 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Russell King - ARM Linux <linux@arm.linux.org.uk>
Date: Mon, 11 Mar 2013 16:47:41 +0000

> On Sun, Mar 10, 2013 at 05:12:38PM -0400, David Miller wrote:
>> From: Chen Gang <gang.chen@asianux.com>
>> Date: Sun, 10 Mar 2013 10:15:54 +0800
>> 
>> > 
>> >   k is u32 which never < 0, need type cast, or cause issue.
>> > 
>> > Signed-off-by: Chen Gang <gang.chen@asianux.com>
>> 
>> Who will apply this, ARM folks or me?
> 
> I'm happy if you wish to take the patch:
> 
> Acked-by: Russell King <rmk+kernel@arm.linux.org.uk>

Great, applied, thanks.
