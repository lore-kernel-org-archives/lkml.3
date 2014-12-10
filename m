Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757244AbaLJHRS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 02:17:18 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:52932 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123AbaLJHRQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 02:17:16 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID sBA7H6wM019195, This message is accepted by code: ctloc85258
From: Hau <hau@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net-next 0/9] r8169:update hardware ephy parameter
Thread-Topic: [PATCH net-next 0/9] r8169:update hardware ephy parameter
Thread-Index: AQHQE8+idbl2pv7EmU64DTY0ajM31ZyHY/6AgAED3IA=
Date: Wed, 10 Dec 2014 07:17:04 +0000
Message-ID: <80377ECBC5453840BA8C7155328B537701085AD8@RTITMBSV03.realtek.com.tw>
References: <1418143563-7652-1-git-send-email-hau@realtek.com>
 <20141209.183549.1930188640715074097.davem@davemloft.net>
In-Reply-To: <20141209.183549.1930188640715074097.davem@davemloft.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.179]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: David Miller [mailto:davem@davemloft.net]
> Sent: Wednesday, December 10, 2014 7:36 AM
> To: Hau
> Cc: netdev@vger.kernel.org; nic_swsd; linux-kernel@vger.kernel.org
> Subject: Re: [PATCH net-next 0/9] r8169:update hardware ephy parameter
> 
> From: Chunhao Lin <hau@realtek.com>
> Date: Wed, 10 Dec 2014 00:45:54 +0800
> 
> > Update hardware ephy parameter to improve pcie compatibility.
> 
> This really doesn't tell me anything, I really dislike patch series like this one.
> 
> All of the programming is magic values to magic offsets.
> 
> You aren't even trying to describe in the commit log message exactly what
> kind of settings are being changed, and exactly how those changes achieve
> the stated goal.
> 
> Furthermore, the commit description makes no sense at all to me.
> 
> How can programming the ethernet MAC PHY have any influence on PCI-E
> bus compatability?  Or are you programming the PCI bus interface's PHY?
> 
> In what way are you adjusting which settings and in what way do those
> adjustments help improve PCI-E bus behavior?
> 
> You absolutely must describe exactly what the new programming is actually
> doing, precisely, and in detail.  I want to know if some kind of timings are
> being adjusted, and in what way.
> Are some fifo limits being changes?  If so, in what way, and why does that
> help.
> 
> You have to describe what you are doing. Short and non-informative commit
> log messages alongside random changes to undocumented magic constant
> registers is simply unacceptable.
> 

These series patch is an alignment with our latest hardware pcie ephy parameters. I will try to explain more on my next patch.

Thanks.
