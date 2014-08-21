Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753253AbaHUCNF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 22:13:05 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:39396 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751860AbaHUCNC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 22:13:02 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.39 with qID s7L2CnLg001702, This message is accepted by code: ctloc85258
From: Hayes Wang <hayeswang@realtek.com>
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: nic_swsd <nic_swsd@realtek.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: RE: [PATCH net-next 3/4] r8152: remove clear_bp function
Thread-Topic: [PATCH net-next 3/4] r8152: remove clear_bp function
Thread-Index: AQHPvFUIMC0XCO2SIU2CCT2BnisNvpvY3f+AgAFyBiA=
Date: Thu, 21 Aug 2014 02:12:48 +0000
Message-ID: <0835B3720019904CB8F7AA43166CEEB2515BB5@RTITMBSV03.realtek.com.tw>
References: <1394712342-15778-16-Taiwan-albertk@realtek.com>
 <1394712342-15778-19-Taiwan-albertk@realtek.com>
 <201408210131.s7L1VuAJ031162@rtits1.realtek.com>
In-Reply-To: <201408210131.s7L1VuAJ031162@rtits1.realtek.com>
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

: Sergei Shtylyov [mailto:sergei.shtylyov@cogentembedded.com] 
> Sent: Wednesday, August 20, 2014 8:01 PM
> To: Hayes Wang; netdev@vger.kernel.org
> Cc: nic_swsd; linux-kernel@vger.kernel.org; linux-usb@vger.kernel.org
> Subject: Re: [PATCH net-next 3/4] r8152: remove clear_bp function
[...]
> >   	r8152b_disable_aldps(tp);
> >
> > -	rtl_clear_bp(tp);
> >
> 
>     Why leave 2 empty lines? One is enough.

The next patch would use another fucntion at the
same location. I skip removing the empty line and
re-adding it again. Is that better to do so? I would
resend the patches if the answer is yes.
 
Best Regards,
Hayes
