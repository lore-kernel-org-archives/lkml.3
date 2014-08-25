Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114AbaHYDXR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 23:23:17 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:50880 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753805AbaHYDXQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 23:23:16 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7P3N5Ot020007, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Francois Romieu <romieu@fr.zoreil.com>
CC: "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 4/4] r8152: support firmware files
Thread-Topic: [PATCH net-next 4/4] r8152: support firmware files
Thread-Index: AQHPvFUJI5Y4Te6UqUOH5yD4+22UEZvfw86AgADp1iA=
Date: Mon, 25 Aug 2014 03:23:06 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2516161@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
 <1394712342-15778-20-Taiwan-albertk@realtek.com>
 <20140824212055.GA30857@electric-eye.fr.zoreil.com>
In-Reply-To: <20140824212055.GA30857@electric-eye.fr.zoreil.com>
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
> > +static void rtl_request_firmware(struct r8152 *tp)
> > +{
> > +	char *fw_name = NULL;
> > +
> > +	if (tp->rtl_fw.fw)
> > +		goto out_request;
> > +
> > +	switch (tp->version) {
> > +	case RTL_VER_01:
> > +		fw_name = "rtl_nic/rtl8152-1.fw";
> > +		break;
> > +	case RTL_VER_02:
> > +		fw_name = "rtl_nic/rtl8152-2.fw";
> > +		break;
> > +	case RTL_VER_03:
> > +		fw_name = "rtl_nic/rtl8153-1.fw";
> > +		break;
> > +	case RTL_VER_04:
> > +		fw_name = "rtl_nic/rtl8153-2.fw";
> > +		break;
> > +	case RTL_VER_05:
> > +		fw_name = "rtl_nic/rtl8153-3.fw";
> > +		break;
> 
> The driver should use MODULE_FIRMWARE() for these files.

Oops. I would fix this. Thanks.
 
Best Regards,
Hayes
