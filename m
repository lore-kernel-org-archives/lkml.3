Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757368AbaHZGs5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 02:48:57 -0400
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:4256 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754354AbaHZGsz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 02:48:55 -0400
From: Yuval Mintz <Yuval.Mintz@qlogic.com>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ariel Elior <Ariel.Elior@qlogic.com>, netdev <netdev@vger.kernel.org>
Subject: RE: randconfig build error with next-20140825, in
 drivers/net/ethernet/broadcom/bnx2x
Thread-Topic: randconfig build error with next-20140825, in
 drivers/net/ethernet/broadcom/bnx2x
Thread-Index: AQHPwJo0NXZ40wyFRUOcX4YUuXn7G5vi3cSA//+UIhA=
Date: Tue, 26 Aug 2014 06:48:45 +0000
Message-ID: <B5657A6538887040AD3A81F1008BEC63B2D063@avmb3.qlogic.org>
References: <CA+r1Zhg7=9-tijyfm6604A6jieX1GCj+xdo20ZDUpjLOAUUpRw@mail.gmail.com>
 <20140826061311.GB2622@sudip-PC>
In-Reply-To: <20140826061311.GB2622@sudip-PC>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7541 signatures=670506
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1408260088
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Building with the attached random configuration file,
> >
> > drivers/built-in.o: In function `__bnx2x_remove':
> > /home/jim/linux/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13409:
> > undefined reference to `ptp_clock_unregister'
> > drivers/built-in.o: In function `bnx2x_register_phc':
> > /home/jim/linux/drivers/net/ethernet/broadcom/bnx2x/bnx2x_main.c:13202:
> > undefined reference to `ptp_clock_register'
> > drivers/built-in.o: In function `bnx2x_get_ts_info':
> >
> /home/jim/linux/drivers/net/ethernet/broadcom/bnx2x/bnx2x_ethtool.c:3498:
> > undefined reference to `ptp_clock_index'
> > make: *** [vmlinux] Error 1
> 
> Hi,I tried to build next-20140825 with your configuration file , but I didn't get any
> error.
> BUILD   arch/x86/boot/bzImage
> Setup is 17068 bytes (padded to 17408 bytes).
> System is 4946 kB
> CRC 13f0e24
> Kernel: arch/x86/boot/bzImage is ready  (#2)
> 
> Am I missing something in the build ?
> 
> Thanks
> Sudip

I believe this is already fixed by commit f79918afb714
("bnx2x: fix build error with ptp") that was submitted a couple of hours ago.

Cheers,
Yuval
