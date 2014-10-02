Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054AbaJBFgB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Oct 2014 01:36:01 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:56234 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaJBFf7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Oct 2014 01:35:59 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s925ZpQD009887, This message is accepted by code: ctloc85258
From: Hau <hau@realtek.com>
To: David Miller <davem@davemloft.net>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 net-next 01/10] r8169:change uppercase numbertolowercase nubmer
Thread-Topic: [PATCH v2 net-next 01/10] r8169:change uppercase number
 tolowercase nubmer
Thread-Index: AQHP3a69pqEvy8V0v0iiDHvFDoa515wcSetw
Date: Thu, 2 Oct 2014 05:35:51 +0000
Message-ID: <80377ECBC5453840BA8C7155328B5377645AB5@RTITMBSV03.realtek.com.tw>
References: <1412176641-24393-1-git-send-email-hau@realtek.com>
 <20141001.153434.1528027414789643819.davem@davemloft.net>
In-Reply-To: <20141001.153434.1528027414789643819.davem@davemloft.net>
Accept-Language: zh-TW, en-US
Content-Language: zh-TW
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.21.71.119]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I will do that next time.

Thanks.

-----Original Message-----
From: David Miller [mailto:davem@davemloft.net] 
Sent: Thursday, October 02, 2014 3:35 AM
To: Hau
Cc: netdev@vger.kernel.org; nic_swsd; linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 net-next 01/10] r8169:change uppercase number tolowercase nubmer

From: Chun-Hao Lin <hau@realtek.com>
Date: Wed, 1 Oct 2014 23:17:12 +0800

> Signed-off-by: Chun-Hao Lin <hau@realtek.com>

Series applied, and I fixed the typo in the Subject line here.

But you _(REALLY)_ need to provide a [PATCH net-next 00/xx] posting at the beginning of the patch series which gives an overview of what the patch series does at a high level, and why.

This also allows me to have a sensible post to reply to when I just need to say what I've done with the entire series rather than providing comments on a specific patch.

Thanks.

------Please consider the environment before printing this e-mail.
