Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752557AbaKFQqN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:46:13 -0500
Received: from hapkido.dreamhost.com ([66.33.216.122]:37483 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaKFQpt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:45:49 -0500
From: "Gerald Coley" <gerald@granddesignsgroup.com>
To: "'Lennart Sorensen'" <lsorense@csclub.uwaterloo.ca>,
        "'Nishanth Menon'" <nm@ti.com>
Cc: "'Tony Lindgren'" <tony@atomide.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <devicetree@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <balbi@ti.com>, <fcooper@ti.com>,
        <beagleboard@googlegroups.com>
References: <1415290702-11353-1-git-send-email-nm@ti.com> <20141106164148.GJ24112@csclub.uwaterloo.ca>
In-Reply-To: <20141106164148.GJ24112@csclub.uwaterloo.ca>
Subject: RE: [PATCH] ARM: dts: Add am57xx-beagle-x15
Date: Thu, 6 Nov 2014 10:44:40 -0600
Message-ID: <006201cff9e0$f6661730$e3324590$@granddesignsgroup.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJ5YymWdDQwubU8pfQPSxvpkvgedgK8xBrBmusVUvA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes. We have three USB 3.0 ports.

Gerald


-----Original Message-----
From: Lennart Sorensen [mailto:lsorense@csclub.uwaterloo.ca] 
Sent: Thursday, November 6, 2014 10:42 AM
To: Nishanth Menon
Cc: Tony Lindgren; linux-kernel@vger.kernel.org;
linux-arm-kernel@lists.infradead.org; devicetree@vger.kernel.org;
linux-omap@vger.kernel.org; balbi@ti.com; gerald@granddesignsgroup.com;
fcooper@ti.com; beagleboard@googlegroups.com
Subject: Re: [PATCH] ARM: dts: Add am57xx-beagle-x15

On Thu, Nov 06, 2014 at 10:18:22AM -0600, Nishanth Menon wrote:
> BeagleBoard-X15 is the next generation Open Source Hardware 
> BeagleBoard based on TI's AM5728 SoC featuring dual core 1.5GHZ A15 
> processor. The platform features 2GB DDR3L (w/dual 32bit busses), 
> eSATA, 3 USB3.0 ports, integrated HDMI (1920x108@60), separate LCD 
> port, video In port, 4GB eMMC, uSD, Analog audio in/out, dual 1G 
> Ethernet.

Oh neat, you put a USB3 hub on the board?

I really should cleanup and submit my patch to make the system time not run
576ppm too fast on the AM57xx.

This will sure be a nice board when you get it released.  I will have to get
one.

--
Len Sorensen

