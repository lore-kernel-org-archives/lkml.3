Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754276AbaJNF5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 01:57:11 -0400
Received: from mail1.bemta7.messagelabs.com ([216.82.254.100]:54008 "EHLO
	mail1.bemta7.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751307AbaJNF5K convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 01:57:10 -0400
X-Greylist: delayed 395 seconds by postgrey-1.27 at vger.kernel.org; Tue, 14 Oct 2014 01:57:10 EDT
X-Env-Sender: Iwo.Mergler@netcommwireless.com
X-Msg-Ref: server-10.tower-170.messagelabs.com!1413265828!10526667!1
X-Originating-IP: [220.233.131.78]
X-StarScan-Received: 
X-StarScan-Version: 6.12.2; banners=netcommwireless.com,-,-
X-VirusChecked: Checked
From: Iwo Mergler <Iwo.Mergler@netcommwireless.com>
To: Huang Shijie <shijie8@gmail.com>,
        Boris Brezillon <boris.brezillon@free-electrons.com>
CC: Mike Voytovich <mvoytovich@paypal.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Roy Lee <roylee@paypal.com>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Date: Tue, 14 Oct 2014 16:50:27 +1100
Subject: RE: [PATCH v3 0/3] mtd: nand: gpmi: add proper raw access support
Thread-Topic: [PATCH v3 0/3] mtd: nand: gpmi: add proper raw access support
Thread-Index: Ac/kmMqcvjDje+R0SM6CbE0jDQzTYAC2LTnR
Message-ID: <EACD232272DA4849B060F0828564D13B44955ABE1F@ntcex01.corp.netcomm.com.au>
References: <1411481256-29141-1-git-send-email-boris.brezillon@free-electrons.com>
 <20141008142437.GA9912@localhost.localdomain>
 <20141008171034.1506550f@bbrezillon>,<20141010144248.GA5107@localhost.localdomain>
In-Reply-To: <20141010144248.GA5107@localhost.localdomain>
Accept-Language: en-US, en-AU
Content-Language: en-AU
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, en-AU
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>
> No, it doesn't seem to be correct.
> But it's an MLC flash, so you'll most probably need to apply this patch
> to nandbiterrs testsuite:
>
> http://code.bulix.org/f69wuu-87021
>
> This patch is flashing the block between each bitflip insertion to
> avoid multiple write without erasure (which, AFAIK, is not supported
> by MLC flashes).

Hi Huang,


just out of interest, have you tried this on the MLC NAND without the patch?

I'm aware that MLC says you shouldn't write multiple times, but that is
with a view towards specified data endurance. I would only expect a few
additional bit errors during the test.

Did you try the overwrite test?

I'm curious how MLC NAND does when subjected to multiple writes.


Best regards,

Iwo

______________________________________________________________________
This communication contains information which may be confidential or privileged. The information is intended solely for the use of the individual or entity named above.  If you are not the intended recipient, be aware that any disclosure, copying, distribution or use of the contents of this information is prohibited.  If you have received this communication in error, please notify me by telephone immediately.
______________________________________________________________________
