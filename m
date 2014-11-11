Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633AbaKKQaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 11:30:15 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:58722 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018AbaKKQaO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 11:30:14 -0500
Date: Tue, 11 Nov 2014 11:30:07 -0500 (EST)
Message-Id: <20141111.113007.194586174190893576.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: valentinrothberg@gmail.com, jcmvbkbc@gmail.com, dg@emlix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: s6gmac: remove driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1415694742.16021.11.camel@x220>
References: <CAMo8BfJ-wvDoDmm+HLHvC3VRUshdqU4eJchOGYt_YJsUktap8Q@mail.gmail.com>
	<20141019.132801.424495087167944921.davem@davemloft.net>
	<1415694742.16021.11.camel@x220>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 11 Nov 2014 08:30:12 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 11 Nov 2014 09:32:22 +0100

> On Sun, 2014-10-19 at 13:28 -0400, David Miller wrote:
>> From: Max Filippov <jcmvbkbc@gmail.com>
>> Date: Sun, 19 Oct 2014 21:26:05 +0400
>> 
>> > On Sun, Oct 19, 2014 at 8:45 PM, David Miller <davem@davemloft.net> wrote:
>> >> From: Daniel Glöckner <dg@emlix.com>
>> >> Date: Sun, 19 Oct 2014 00:49:05 +0200
>> >>
>> >>> The s6000 Xtensa support is removed from the kernel. There are no
>> >>> other chips using this driver.
>> >>
>> >> That's not what I see in Linus's current tree:
>> > 
>> > David, s6000 removal is queued for 3.18.
>> 
>> Then there is zero reason for me to apply this to my networking
>> tree.
> 
> Commit 4006e565e150 ("xtensa: remove s6000 variant and s6105 platform")
> is included in linux-next as of next-20141111. So now we see:
>     $ git grep XTENSA_VARIANT_S6000 next-20141111
>     next-20141111:drivers/net/ethernet/Kconfig:     depends on XTENSA_VARIANT_S6000
> 
> Should Daniel resubmit, for net-next, perhaps with a commit explanation
> that references this commit?

When the s6000 removal shows up in Linus's tree, submit it.
