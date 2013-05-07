Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758192Ab3EGSZE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 14:25:04 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:40761 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab3EGSZB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 14:25:01 -0400
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="45080510"
X-IronPort-AV: E=Sophos;i="4.87,629,1363158000"; 
   d="scan'208";a="444301546"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Bjorn Helgaas <bhelgaas@google.com>
CC: "Joseph A. Millikan" <josephamillikan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ren, Cloud" <cjren@qca.qualcomm.com>, netdev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Subject: RE: 3.8.4 kernel
Thread-Topic: 3.8.4 kernel
Thread-Index: AQHOSsYBD1m+WQNh20GlmxOtzu7nipj5AxFggAFaPQD//6PJoA==
Date: Tue, 7 May 2013 18:24:59 +0000
Message-ID: <157393863283F442885425D2C45428564F219C97@nasanexd02f.na.qualcomm.com>
References: <5153620E.4010608@gmail.com>
 <CAErSpo6w+tTbwJ7Qinpd0Vx20q5cm2gMvqzE1Do+2=G3b8rcHA@mail.gmail.com>
 <CAErSpo6iwM2r8b-aoiBPjQpkdpcfgLiO+WkpiM1wFsDhxuSXPg@mail.gmail.com>
 <CAErSpo68AWCGWQHKgoKuD-QFA0b+jbCRf7T_PzzKoUsVwdZHOg@mail.gmail.com>
 <157393863283F442885425D2C45428564F219B3B@nasanexd02f.na.qualcomm.com>
 <CAErSpo44-f4UdXxO5MdwVg09LFABwFQ320gG8v8jHcYh=5gqvA@mail.gmail.com>
In-Reply-To: <CAErSpo44-f4UdXxO5MdwVg09LFABwFQ320gG8v8jHcYh=5gqvA@mail.gmail.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [199.106.115.132]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> Joseph, if there's no hardware switch for the wireless on your G770, you can
> probably still take wireless out of the picture by removing or renaming the
> bcma module (look in /lib/modules/.../kernel/drivers/bcma/), then rebooting.
> 
> Xiong, do you have a specific network manager-related test that Joseph could
> perform?  I don't want to burden Joseph with a lot of debugging because he's
> currently happy with 3.6.11 and testing is pretty disruptive in his environment.
> 

There is a stranger behavior for this issue: if only enable either one (Ethernet or Wlan), everything looks OK.
But once enable both, the issue arises.

And Misha Labjuk said:
------->
Comment #38 From Misha Labjuk 2013-03-10 21:10:15 (-) [reply] 02:00.0 Ethernet controller: Qualcomm Atheros AR8152 v2.0 Fast Ethernet (rev
c1)

If configured by iproute2 (ip addr add...) stable working.
If NetworkManager running (just running, not managing) - ethernet die after 1-5
min. After "mii-tool -r eth0" working until next freeze.
<------

Unfortunately, I have no idea about NetworkManager :(

BR.
Xiong

