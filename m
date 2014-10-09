Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752784AbaJIH7x (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 03:59:53 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:43213 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbaJIH7j convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 03:59:39 -0400
Authenticated-By: 
X-SpamFilter-By: BOX Solutions SpamTrap 5.49 with qID s997xZFI007734, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Hayes Wang <hayeswang@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next] r8152: add rtnl_lock
Thread-Topic: [PATCH net-next] r8152: add rtnl_lock
Thread-Index: AQHP44nVc87gpVi0xk2U6xtPyF6zppwnZhDA
Date: Thu, 9 Oct 2014 07:59:35 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2EC397E@RTITMBSTEMP01.realtek.com.tw>
References: <1394712342-15778-58-Taiwan-albertk@realtek.com>
 <1394712342-15778-59-Taiwan-albertk@realtek.com>
In-Reply-To: <1394712342-15778-59-Taiwan-albertk@realtek.com>
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

> -----Original Message-----
> From: Hayes Wang 
> Sent: Thursday, October 09, 2014 2:25 PM
> To: netdev@vger.kernel.org
> Cc: nic_swsd; linux-kernel@vger.kernel.org; 
> linux-usb@vger.kernel.org; Hayes Wang
> Subject: [PATCH net-next] r8152: add rtnl_lock
> 
> Add rtnl_lock() for suspend/resume and workqueue.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>

Excuse me. The patch has the dead lock issue when
enabling autosuspend. Please ignore this patch.
 
Best Regards,
Hayes
