Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583AbaGXJCB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 05:02:01 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:60002 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750787AbaGXJB6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 05:01:58 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s6O91SA5018939, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Borislav Petkov <bp@alien8.de>, nic_swsd <nic_swsd@realtek.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: RE: 3.16-rc6+: r8169 fresh new irq lock inversion
Thread-Topic: 3.16-rc6+: r8169 fresh new irq lock inversion
Thread-Index: AQHPpYWTfukIsSAVWEa5YPhOBYAmr5uu6wMg
Date: Thu, 24 Jul 2014 09:01:27 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2510016@RTITMBSV03.realtek.com.tw>
References: <20140722081840.GA6462@pd.tnic>
In-Reply-To: <20140722081840.GA6462@pd.tnic>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.143]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Borislav Petkov [mailto:bp@alien8.de] 
> Sent: Tuesday, July 22, 2014 4:19 PM
> To: nic_swsd
> Cc: netdev@vger.kernel.org; lkml
> Subject: 3.16-rc6+: r8169 fresh new irq lock inversion
> 
> Hi all,
> 
> I got this new lockdep splat after booting rc6 + tip/master this
> morning. I haven't seen it before so it must be new in rc6 
> which should
> be easy to pinpoint... or maybe there's already a fix queued 
> somewhere. :)

I have no idea about why you see the messages.  I don't think
the patches which submitted previously for r8169.c  would cause
the problem. Although I have submitted some patches about IPv6,
the hw checksum should be off by default. That is, the behavior
should be the same with the previous one.
 
Best Regards,
Hayes
