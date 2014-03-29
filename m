Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751554AbaC2JMZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 05:12:25 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:42913 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751204AbaC2JMX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 05:12:23 -0400
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        Dept-HSG Linux NIC Dev <Dept-HSGLinuxNICDev@qlogic.com>
Subject: RE: linux-next: Tree for Mar 28 (qlcnic)
Thread-Topic: linux-next: Tree for Mar 28 (qlcnic)
Thread-Index: AQHPSrNKNKIaRbq9tkC5D24MIiySA5r3xPaw
Date: Sat, 29 Mar 2014 09:11:52 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A46F881E9@avmb2.qlogic.org>
References: <20140328180950.322d12920ce31e0ad3dace59@canb.auug.org.au>
 <5335BEE1.4030609@infradead.org>
In-Reply-To: <5335BEE1.4030609@infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7391 signatures=670392
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1403290019
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> -----Original Message-----
> From: Randy Dunlap [mailto:rdunlap@infradead.org]
> Sent: Friday, March 28, 2014 11:57 PM
> To: Stephen Rothwell; linux-next@vger.kernel.org
> Cc: linux-kernel; netdev; Shahed Shaikh; Dept-HSG Linux NIC Dev
> Subject: Re: linux-next: Tree for Mar 28 (qlcnic)
> 
> On 03/28/2014 12:09 AM, Stephen Rothwell wrote:
> > Hi all,
> >
> > This tree still fails (more than usual) the powerpc allyesconfig build.
> >
> > Changes since 20140327:
> >
> 
> 
> on x86_64:
> CONFIG_VXLAN=m
> 
> drivers/built-in.o: In function `qlcnic_attach':
> (.text+0x25d9dc): undefined reference to `vxlan_get_rx_port'
> 
> 
> Full randconfig file is attached.
> 
> depends on VXLAN ?

Yes. Need to add dependency on VXLAN in Kconfig of qlcnic. I will send a patch to fix this build failure.

Thanks,
Shahed
> 
> --
> ~Randy
