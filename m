Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754767AbaIPDXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 23:23:44 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43269 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752914AbaIPDXn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 23:23:43 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s8G3N5BC016682, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Francois Romieu <romieu@fr.zoreil.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH net 1/2] r8169: fix the default setting of rx vlan
Thread-Topic: [PATCH net 1/2] r8169: fix the default setting of rx vlan
Thread-Index: AQHPzjqtmgodqv8pvE6c+FoE9zRS35v9YCwAgAQplWCAANbugIAAuZEg
Date: Tue, 16 Sep 2014 03:23:05 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB25232A5@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-38-Taiwan-albertk@realtek.com>
 <1394712342-15778-39-Taiwan-albertk@realtek.com>
 <20140912194014.GA15496@electric-eye.fr.zoreil.com>
 <0835B3720019904CB8F7AA43166CEEB2523183@RTITMBSV03.realtek.com.tw>
 <20140916000321.GA19564@electric-eye.fr.zoreil.com>
In-Reply-To: <20140916000321.GA19564@electric-eye.fr.zoreil.com>
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

 From: Francois Romieu [mailto:romieu@fr.zoreil.com] 
> Sent: Tuesday, September 16, 2014 8:03 AM
[...]
> However it's getting messy and the code stomps CPlusCmd in 
> rtl_open right
> before it's given a chance to be read in hw_start. Something like the
> untested patch below should avoid it and keep related things together.

You are right. Your patch is more reasonable. I would sent the patch.
Thanks.
 
Best Regards,
Hayes
