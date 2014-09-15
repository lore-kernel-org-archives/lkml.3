Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753129AbaIODXK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2014 23:23:10 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:42469 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752151AbaIODXI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2014 23:23:08 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8F3Msdj020236, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Francois Romieu <romieu@fr.zoreil.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] r8169: fix the default setting of rx vlan
Thread-Topic: [PATCH net 1/2] r8169: fix the default setting of rx vlan
Thread-Index: AQHPzjqtmgodqv8pvE6c+FoE9zRS35v9YCwAgAQplWA=
Date: Mon, 15 Sep 2014 03:22:54 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2523183@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-38-Taiwan-albertk@realtek.com>
 <1394712342-15778-39-Taiwan-albertk@realtek.com>
 <20140912194014.GA15496@electric-eye.fr.zoreil.com>
In-Reply-To: <20140912194014.GA15496@electric-eye.fr.zoreil.com>
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
> Sent: Saturday, September 13, 2014 3:40 AM
[...]
> The same fix should be relevant for NETIF_F_RXCSUM. You may thus as
> well remove the "changed" test in __rtl8169_set_features and keep
> everything there.

In the probe function (rtl_init_one), RxChkSum has been assgined to
tp->cp_cmd, so only the vlan setting is incorrect. Therefore, I fix
it only. Do I still have to remove the "changed" test?
 
Best Regards,
Hayes
