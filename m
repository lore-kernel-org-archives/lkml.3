Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231AbaF3Mol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 08:44:41 -0400
Received: from mail6.autoliv.com ([195.33.130.243]:41193 "EHLO
	mail6.autoliv.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754839AbaF3MbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 08:31:02 -0400
From: Fredrik Noring <fredrik.noring@autoliv.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Mattis Lorentzon <Mattis.Lorentzon@autoliv.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Topic: Oops: 17 SMP ARM (v3.16-rc2)
Thread-Index: Ac+QeuMIv4ry9FBDTNKHf1ccZ0ioqQAu3GGAAAUkuuD//+tKAIABUVuA//+RU9CAAMUXAP/7a+yw
Date: Mon, 30 Jun 2014 12:30:57 +0000
Message-ID: <3FFB61A7A8473C49831AF20FA193534A43CB69F6@ALVA-EXMB01.alv.autoliv.int>
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
x-tm-as-product-ver: SMEX-10.2.0.2087-7.500.1017-20788.006
x-tm-as-result: No--40.228100-8.000000-31
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

It seems to be a compiler issue, where (GCC) 4.8.2 does not produce a properly
working kernel. Happily, (Fedora 2013.11.24-2.fc19) 4.8.1 appears to do a lot
better. No crashes so far with v3.16-rc2!

All the best,
Fredrik

> -----Original Message-----
> Hi Fredrik,
> 
> On Fri, Jun 27, 2014 at 04:16:57PM +0000, Fredrik Noring wrote:
> > Please find below a trace that appeared once with 3.16-rc2. Perhaps it
> > is of some interest?
> 
> It's not that serious... I know that the FEC ethernet driver is horrendously
> racy (I have had a patch set for about the last six months which fixes some of
> its problems) but as I've had a lot of patches to deal with, and it's been
> pushed to the back of the queue...
> 
> The races don't lead to data corruption though, merely timeouts and some
> lost packets.
> 
> Now because things have changed during the last merge window, I've got an
> even bigger problem sorting through that patch set and getting it back into a
> submittable state.  I've just sent out v2 for it onto the
> netdev@vger.kernel.org mailing list.
> 
> The initial version (marked RFC) attracted very little interest from testers, or
> acks.  I'd very much like to have some testing of it, so if you want to try it
> out, I can provide you with a git URL, patches or a combined patch.
> 
> --
> FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
> improving, and getting towards what was expected from it.
***************************************************************
Consider the environment before printing this message.

To read Autoliv's Information and Confidentiality Notice, follow this link:
http://www.autoliv.com/disclaimer.html
***************************************************************

