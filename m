Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752117AbaKCMfr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 07:35:47 -0500
Received: from rtits2.realtek.com ([60.250.210.242]:37482 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaKCMfo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 07:35:44 -0500
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID sA3CZUqO028301, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Francois Romieu <romieu@fr.zoreil.com>
CC: David Miller <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next v2 2/3] r8152: clear theflagofSCHEDULE_TASKLETin tasklet
Thread-Topic: [PATCH net-next v2 2/3] r8152: clear the
 flagofSCHEDULE_TASKLETin tasklet
Thread-Index: AQHP9u/Lm+d6J+vpuUCx77nj0BaItJxO0rlw
Date: Mon, 3 Nov 2014 12:35:29 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2ECD9F4@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-75-Taiwan-albertk@realtek.com>
 <1394712342-15778-79-Taiwan-albertk@realtek.com>
 <1394712342-15778-81-Taiwan-albertk@realtek.com>
 <20141031.161520.3547230591227504.davem@davemloft.net>
 <0835B3720019904CB8F7AA43166CEEB2ECD8A7@RTITMBSV03.realtek.com.tw>
 <20141102225307.GA19900@electric-eye.fr.zoreil.com>
In-Reply-To: <20141102225307.GA19900@electric-eye.fr.zoreil.com>
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
[...]
> test_and_clear_bit (dense) or clear_bit would be more idiomatic.

Excuse me. If I use clear_bit without test_bit or test_and_clear_bit,
they alwayes call the spin lock. However, for my original flow, the spin
lock is only called when the clear_bit is necessary. Is that better?
 
Best Regards,
Hayes
