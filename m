Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717AbaHFLKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 07:10:10 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:41063 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754828AbaHFLKI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 07:10:08 -0400
From: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Fredrik Noring <fredrik.noring@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9CAAMUXAP/CyllwgHui4wD//8wREA==
Date: Wed, 6 Aug 2014 11:10:06 +0000
Message-ID: <C4A61A5CA4AD2246942F4BA6F20ACB8043575172@ALVA-EXMB04.alv.autoliv.int>
References: <C4A61A5CA4AD2246942F4BA6F20ACB804356534D@ALVA-EXMB04.alv.autoliv.int>
 <20140626140115.GQ32514@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB80435655E9@ALVA-EXMB04.alv.autoliv.int>
 <20140626151424.GT32514@n2100.arm.linux.org.uk>
 <20140627112151.GF32514@n2100.arm.linux.org.uk>
 <3FFB61A7A8473C49831AF20FA193534A43CADFA7@ALVA-EXMB01.alv.autoliv.int>
 <20140627163108.GP32514@n2100.arm.linux.org.uk>
 <C4A61A5CA4AD2246942F4BA6F20ACB8043575072@ALVA-EXMB04.alv.autoliv.int>
 <20140806095012.GN30282@n2100.arm.linux.org.uk>
In-Reply-To: <20140806095012.GN30282@n2100.arm.linux.org.uk>
Accept-Language: sv-SE, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.14.8.137]
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell,

> What is on the other end of the link?

16 ARM cards connected to a 3Com Switch 4400 connected to a Linux FC 20
machine (Intel Corporation 82541PI Gigabit Ethernet Controller rev 05).

There may be multiple problems. The backtrace has only been seen a few
times, on two different cards. Most of the time, the network for a random
card just stalls without any visible backtrace or error messages. The other
cards seem to be unaffected when this happens.

> What I would like to do is to stamp each packet in some way with an
> identifier marking its ring position, and then monitor the network to find out
> whether the packet at slot 85 was actually transmitted - that's made slightly
> harder because packets may be dropped at the receiver when operating in
> promisc mode.  This would then allow us to work out some likely causes.

We would be glad to run this test on our setup, do you have more detailed
information on how to set it up?

> Note that after the transmit watchdog, the interface should recover and start
> operating normally again - and that should not take "several minutes."

After a network stall, we usually have to powercycle the ARM hardware to
get it back to a usable state. These stalls last at least several minutes,
perhaps indefinitely. It does not seem to recover properly, and is no longer
reachable via the network.

Best regards,
Mattis Lorentzon
***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************

