Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754691AbaGIGgS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:36:18 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:41596 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbaGIGgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:36:15 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s696a5jb017450, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Francois Romieu <romieu@fr.zoreil.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>
Subject: RE: [PATCH net] r8169: disable L23
Thread-Topic: [PATCH net] r8169: disable L23
Thread-Index: AQHPmoZbW/3+J0HPL0qr/A2kidAPWZuWF9kAgAEsuSA=
Date: Wed, 9 Jul 2014 06:36:05 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2505DFA@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-6-Taiwan-albertk@realtek.com>
 <20140708201630.GA31885@electric-eye.fr.zoreil.com>
In-Reply-To: <20140708201630.GA31885@electric-eye.fr.zoreil.com>
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

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Wednesday, July 09, 2014 4:17 AM
> To: Hayes Wang
> Cc: netdev@vger.kernel.org; linux-kernel@vger.kernel.org; nic_swsd
> Subject: Re: [PATCH net] r8169: disable L23
[...]
> Can you elaborate what L23 is or should the commit message be reworded
> as "Disable a (yet undocumented) power saving feature that randomly
> causes RTL8411, RTL8111G, RTL8402, RTL8105, and RTL8106 devices to be
> lost on some systems." ?

The L2/L3 are the link status which are defined in the specification of the PCI
Express Base Specification for the link state power manager. I don't know them
much, so I don't sure if I could explain them clearly. 

Best Regards,
Hayes
