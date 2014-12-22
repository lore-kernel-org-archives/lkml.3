Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753880AbaLVCXM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2014 21:23:12 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:47035 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753800AbaLVCXK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2014 21:23:10 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.52 with qID sBM2MtiG014389, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Tom Herbert <therbert@google.com>, David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net] r8152: drop the tx packet with invalid length
Thread-Topic: [PATCH net] r8152: drop the tx packet with invalid length
Thread-Index: AQHQCV9ExQJeo8eXJ0uzTHR36OfvLZxymd4AgAAEDQCAABszgIAAHqAAgCO8/BCAADcggIAACmeAgAQxjSA=
Date: Mon, 22 Dec 2014 02:22:54 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ED5A08@RTITMBSV03.realtek.com.tw>
References: <1417020748.29427.59.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141126.120658.498602780456343676.davem@davemloft.net>
	 <1417027459.29427.63.camel@edumazet-glaptop2.roam.corp.google.com>
	 <20141126.153356.461494573591656082.davem@davemloft.net>
	 <0835B3720019904CB8F7AA43166CEEB2ED585A@RTITMBSV03.realtek.com.tw>
	 <1419010603.9773.84.camel@edumazet-glaptop2.roam.corp.google.com>
 <1419012837.9773.85.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1419012837.9773.85.camel@edumazet-glaptop2.roam.corp.google.com>
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

 Eric Dumazet [mailto:eric.dumazet@gmail.com] 
> Sent: Saturday, December 20, 2014 2:14 AM
[...]
> Could you try following patch ?

Thank you. I would test it.
 
Best Regards,
Hayes
