Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760303Ab3EGCwC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 22:52:02 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:44059 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758590Ab3EGCv7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 22:51:59 -0400
X-IronPort-AV: E=Sophos;i="4.87,625,1363158000"; 
   d="scan'208";a="44860391"
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="479598912"
From: "Huang, Xiong" <xiong@qca.qualcomm.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        "Joseph A. Millikan" <josephamillikan@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Ren, Cloud" <cjren@qca.qualcomm.com>, netdev <netdev@vger.kernel.org>
Subject: RE: 3.8.4 kernel
Thread-Topic: 3.8.4 kernel
Thread-Index: AQHOSsYBD1m+WQNh20GlmxOtzu7nipj5AxFg
Date: Tue, 7 May 2013 02:51:58 +0000
Message-ID: <157393863283F442885425D2C45428564F219B3B@nasanexd02f.na.qualcomm.com>
References: <5153620E.4010608@gmail.com>
 <CAErSpo6w+tTbwJ7Qinpd0Vx20q5cm2gMvqzE1Do+2=G3b8rcHA@mail.gmail.com>
 <CAErSpo6iwM2r8b-aoiBPjQpkdpcfgLiO+WkpiM1wFsDhxuSXPg@mail.gmail.com>
 <CAErSpo68AWCGWQHKgoKuD-QFA0b+jbCRf7T_PzzKoUsVwdZHOg@mail.gmail.com>
In-Reply-To: <CAErSpo68AWCGWQHKgoKuD-QFA0b+jbCRf7T_PzzKoUsVwdZHOg@mail.gmail.com>
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

> >
> > Did this ever get resolved?
> 
> I opened https://bugzilla.kernel.org/show_bug.cgi?id=57681 to keep track of
> this and attached the dmesg logs you collected.  If you have a chance, could you
> also collect and attach the output of "lspci -vv"
> (any kernel is fine for this).
> 
> I don't see anything obvious wrong, at least from the PCI side.  Maybe the atl1c
> guys will have some ideas.
> 

Hi Bjorn and All
     This issue should be same as bug https://bugzilla.kernel.org/show_bug.cgi?id=54021
     I didn't find any abnormal info from the log and the PHY link is stable as well :(
     Is it related to the network manager ?

BR.
Xiong

