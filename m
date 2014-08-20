Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751917AbaHTNcu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 09:32:50 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:61638 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaHTNcs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 09:32:48 -0400
MIME-Version: 1.0
In-Reply-To: <0835B3720019904CB8F7AA43166CEEB251585A@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
	<1394712342-15778-20-Taiwan-albertk@realtek.com>
	<CAN_we7P2LDvR8miAsoSeL6+iEOK+ucgjRDC8jtPbc4_-2nn7MQ@mail.gmail.com>
	<0835B3720019904CB8F7AA43166CEEB251585A@RTITMBSV03.realtek.com.tw>
Date: Wed, 20 Aug 2014 15:32:45 +0200
Message-ID: <CAN_we7O=wmpRfJ0Rts_sCxL-BUE2XemiekLRwmCMudEd05ZFXg@mail.gmail.com>
Subject: Re: [PATCH net-next 4/4] r8152: support firmware files
From: Daniele Forsi <dforsi@gmail.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-08-20 14:35 GMT+02:00 Hayes Wang:

> Is this necessary? Besides the check of the "start",
> there are checks of the "size" and rtl_fw_data_ok().
> I think they cover the situations which you indicate.

it's not necessary and it's better checked later as you did!

-- 
Daniele Forsi
