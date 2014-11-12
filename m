Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965358AbaKLBpZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:45:25 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:37159 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934748AbaKLBpR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:45:17 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sAC1j9fY028115, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
Thread-Topic: [PATCH net-next 2/2] r8152: adjust rtl_start_rx
Thread-Index: AQHP+nD06ZRj/kse50uRMFsgi72OwJxU1qgAgAdoTSA=
Date: Wed, 12 Nov 2014 01:45:08 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ECE337@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-88-Taiwan-albertk@realtek.com>
	<1394712342-15778-90-Taiwan-albertk@realtek.com>
 <20141107.113522.837502028522211960.davem@davemloft.net>
In-Reply-To: <20141107.113522.837502028522211960.davem@davemloft.net>
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

David Miller [mailto:davem@davemloft.net] 
> Sent: Saturday, November 08, 2014 12:35 AM
[...]
> Does this even work?
> 
> If you leave a hole in the ring, the device is going to stop there
> anyways.
> 
> So better to replenish the next time you call into this function
> rather than leaving gaps in your receive ring.

Excuse me. Is this still unacceptable?
Should I remove this patch for keeping the original flow?
 
Best Regards,
Hayes
