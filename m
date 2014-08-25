Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190AbaHYDnS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:43:18 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:38884 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaHYDnP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:43:15 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7P3h78j025788, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 0/4] r8152: firmware support
Thread-Topic: [PATCH net-next 0/4] r8152: firmware support
Thread-Index: AQHPvFUGvJCSNb1dlUOr/EZt9Z/MxJvc+J+AgAO4krA=
Date: Mon, 25 Aug 2014 03:43:04 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2516177@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
 <20140822.194111.760144805197214266.davem@davemloft.net>
In-Reply-To: <20140822.194111.760144805197214266.davem@davemloft.net>
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

 From: David Miller [mailto:davem@davemloft.net] 
[...]
> You haven't told us why you need to do this.
> 
> These are just programming registers in the chip, and I see no reason
> to not keep these in the driver with real code.
> 
> I'm not applying this series, you haven't explained what is happening
> here and the reason for doing so.  Ironically, that's exactly what you
> are supposed to provide in this 0/4 header email.

The nic has the MCU inside which is used to fix the PHY,
MAC, and some behavior of the USB device. Each parts have
different methods of updating the firmware by accessing the
registers. The firmware files are used to deal with the
processes, so I need some functions to parse the firmware
files to update the fimrware code.

I would resend these. Sorry.
 
Best Regards,
Hayes
