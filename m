Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758263AbaGOJaE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 05:30:04 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:56412 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756689AbaGOJaA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 05:30:00 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s6F9TcgC026754, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: =?iso-8859-1?Q?Michel_D=E4nzer?= <michel@daenzer.net>,
        Francois Romieu <romieu@fr.zoreil.com>,
        nic_swsd <nic_swsd@realtek.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
Thread-Topic: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
Thread-Index: AQHPn/fgi0fnUCVeFUeOK01rYq/7rZug3KMg
Date: Tue, 15 Jul 2014 09:29:39 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB25066DC@RTITMBSV03.realtek.com.tw>
References: <1405406500-1208-1-git-send-email-michel@daenzer.net>
In-Reply-To: <1405406500-1208-1-git-send-email-michel@daenzer.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.143]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 Michel Dänzer [mailto:michel@daenzer.net] 
> Sent: Tuesday, July 15, 2014 2:42 PM
> To: Francois Romieu; nic_swsd
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> Subject: [PATCH] r8169: Enable RX_MULTI_EN for RTL_GIGA_MAC_VER_40
> 
> Without this, the ethernet port on my ASUS A88X Pro mainboard stops
> working sometimes, with messages like these in dmesg:
> 
> AMD-Vi: Event logged [IO_PAGE_FAULT device=05:00.0 
> domain=0x001e address=0x0000000000003000 flags=0x0050]

I search the information about your issue. It seems to be
relative to the IOMMU. I don't sure if your patch is the root
cause or a workaround.
 
Best Regards,
Hayes
