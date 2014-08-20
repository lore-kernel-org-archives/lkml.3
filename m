Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314AbaHTMfT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:35:19 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52403 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752385AbaHTMfQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 08:35:16 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7KCZ9KI027020, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Daniele Forsi <dforsi@gmail.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 4/4] r8152: support firmware files
Thread-Topic: [PATCH net-next 4/4] r8152: support firmware files
Thread-Index: AQHPvFUJI5Y4Te6UqUOH5yD4+22UEZvY3hKAgACKVgA=
Date: Wed, 20 Aug 2014 12:35:09 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB251585A@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
	<1394712342-15778-20-Taiwan-albertk@realtek.com>
 <CAN_we7P2LDvR8miAsoSeL6+iEOK+ucgjRDC8jtPbc4_-2nn7MQ@mail.gmail.com>
In-Reply-To: <CAN_we7P2LDvR8miAsoSeL6+iEOK+ucgjRDC8jtPbc4_-2nn7MQ@mail.gmail.com>
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

 Daniele Forsi [mailto:dforsi@gmail.com] 
> Sent: Wednesday, August 20, 2014 8:01 PM
> To: Hayes Wang
> Cc: netdev@vger.kernel.org; nic_swsd; 
> linux-kernel@vger.kernel.org; USB list
> Subject: Re: [PATCH net-next 4/4] r8152: support firmware files
[...]
> > +       start = le32_to_cpu(fw_header->fw_start);
> > +       if (start > fw->size)
> > +               goto out;
> 
> since "start" is an offset in an array of size "fw->size" this should
> check for ">=" and if a command is at least cmd(2 bytes) + length(2
> bytes), shouldn't this check for "start >= fw->size - 4"?

Is this necessary? Besides the check of the "start",
there are checks of the "size" and rtl_fw_data_ok().
I think they cover the situations which you indicate.
 
Best Regards,
Hayes
