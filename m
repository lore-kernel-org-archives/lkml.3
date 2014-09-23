Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755838AbaIWLMB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 07:12:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:30032 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755290AbaIWLL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 07:11:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,579,1406617200"; 
   d="scan'208";a="607097786"
From: "Sharma, Karun" <karun.sharma@intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: 3.17 kernel crash while loading IPoIB
Thread-Topic: 3.17 kernel crash while loading IPoIB
Thread-Index: Ac/W7VpLRE13qYLTTwWCP2HykhVlC///5C0A//+A9uA=
Date: Tue, 23 Sep 2014 11:11:53 +0000
Message-ID: <637AD4DF2E595346BAB0DF8C46F3A2B0032921A7@BGSMSX101.gar.corp.intel.com>
References: <637AD4DF2E595346BAB0DF8C46F3A2B003291F06@BGSMSX101.gar.corp.intel.com>
 <1411463138.26859.168.camel@edumazet-glaptop2.roam.corp.google.com>
In-Reply-To: <1411463138.26859.168.camel@edumazet-glaptop2.roam.corp.google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s8NBC6Lw003770

Thanks Eric. Yes, the commits below have fixed the issue.

Regards,
Karun Sharma


-----Original Message-----
From: Eric Dumazet [mailto:eric.dumazet@gmail.com] 
Sent: Tuesday, September 23, 2014 2:36 PM
To: Sharma, Karun
Cc: linux-kernel@vger.kernel.org; netdev@vger.kernel.org
Subject: Re: 3.17 kernel crash while loading IPoIB

On Tue, 2014-09-23 at 05:15 +0000, Sharma, Karun wrote:
> Hello:
> 
> I am facing an issue wherein kernel 3.17 crashes while loading IPoIB 
> module. I guess the issue discussed in this thread
> (https://www.mail-archive.com/linux-rdma@vger.kernel.org/msg20963.html) is similar.
> 
> We were able to reproduce the issue with RC6 also. Here are the steps 
> I followed:
> 
> I compiled and installed 3.17 kernel on top of RHEL 6.5. 
> Then I changed rdma.conf to not load IPoIB (If I don't do this, the 
> kernel crashes while booting and starting RDMA service.) After the 
> server comes up, I just did "modprobe ib_ipoib" and kernel crashes.
> Please see below the kernel back trace.
> 
> Seeing the announcement, it looks like RC6 will be the last RC for
> 3.17 kernel. Will the release happen with this issue? Is there any 
> workaround available for this issue?
> I am not sure what mechanism/process is used to report issue to kernel 
> community.
> 
> Regards
> Karun

This seems fixed now :

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=257117862634d89de33fec74858b1a0ba5ab444b

http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=b49fe36208b45f76dfbcfcd3afd952a33fa9f5ce


ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
