Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157AbaIACrM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 22:47:12 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:36168 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751679AbaIACq4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 22:46:56 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s812kcee031278, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next v2] r8152: reduce the number of Tx
Thread-Topic: [PATCH net-next v2] r8152: reduce the number of Tx
Thread-Index: AQHPwmctYgiyAWbIckGtQl8Niiizqpvn+Q8AgAObLiA=
Date: Mon, 1 Sep 2014 02:46:38 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2516A75@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-23-Taiwan-albertk@realtek.com>
	<1394712342-15778-24-Taiwan-albertk@realtek.com>
 <20140829.202504.655684636693672249.davem@davemloft.net>
In-Reply-To: <20140829.202504.655684636693672249.davem@davemloft.net>
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
> This driver has a loop that iterates MAX_TX times to initialize both
> the RX and TX buffers.
> 
> So if they are not equal, it can't possibly work.

Excuse me. I don't find that the "RTL8152_MAX_TX" is used by
rx buffer. The rx buffer only use "RTL8152_MAX_RX". Although 
the tx buffer size is determined by "rx_buf_sz", the tx buffers
are independent of rx buffers.

Best Regards,
Hayes
