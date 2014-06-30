Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137AbaF3GWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 02:22:40 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:51199 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaF3GWi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 02:22:38 -0400
From: Fredrik Noring <fredrik.noring@autoliv.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9CAAMUXAP/72MIA
Date: Mon, 30 Jun 2014 06:22:33 +0000
Message-ID: <3FFB61A7A8473C49831AF20FA193534A43CB1887@ALVA-EXMB01.alv.autoliv.int>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int>
 <20140626140115.GQ32514@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>
 <20140626151424.GT32514@n2100.arm.linux.org.uk>
 <20140627112151.GF32514@n2100.arm.linux.org.uk>
 <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
 <20140627163108.GP32514@n2100.arm.linux.org.uk>
In-Reply-To: <20140627163108.GP32514@n2100.arm.linux.org.uk>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.8.136]
x-tm-as-product-ver: SMEX-10.2.0.2087-7.500.1017-20788.004
x-tm-as-result: No--25.100700-8.000000-31
x-tm-as-user-approved-sender: No
x-tm-as-user-blocked-sender: No
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russell,

> -----Original Message-----
> It's not that serious... I know that the FEC ethernet driver is horrendously
> racy (I have had a patch set for about the last six months which fixes some of
> its problems) but as I've had a lot of patches to deal with, and it's been
> pushed to the back of the queue...
> 
> The races don't lead to data corruption though, merely timeouts and some
> lost packets.

The serial port (uart1) and Ethernet are essentially the only things we use.
No disks, no graphics, no USB, etc. If not the Ethernet driver, what else is
likely to crash NFS so badly?

Also, we are happy to change our config if that would simplify things:

http://lkml.iu.edu/hypermail/linux/kernel/1406.3/01488/config.gz

> Now because things have changed during the last merge window, I've got an
> even bigger problem sorting through that patch set and getting it back into a
> submittable state.  I've just sent out v2 for it onto the
> netdev@vger.kernel.org mailing list.
> 
> The initial version (marked RFC) attracted very little interest from testers, or
> acks.  I'd very much like to have some testing of it, so if you want to try it
> out, I can provide you with a git URL, patches or a combined patch.

Sure! A combined gzip patch attachment is fine. Git over HTTP probably works
too.

All the best,
Fredrik

***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************

