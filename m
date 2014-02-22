Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaBVQSP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 11:18:15 -0500
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:36882 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751557AbaBVQSM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 11:18:12 -0500
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel <linux-kernel@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Subject: RE: [PATCH net-next 28/35] qlcnic: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Thread-Topic: [PATCH net-next 28/35] qlcnic: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Thread-Index: AQHPLJG9mZlEjDA31EqBLpkiuLo1TZrA+3YAgAABMoCAAJATAP//7Jdw
Date: Sat, 22 Feb 2014 16:18:04 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A46F6F3A2@avmb2.qlogic.org>
References: <cover.1392717502.git.agordeev@redhat.com>
 <cb8eb41f672c62d1149c375bdaf97ca3328703f9.1392717503.git.agordeev@redhat.com>
 <1393029870.15717.71.camel@deadeye.wl.decadent.org.uk>
 <1393030127.15717.72.camel@deadeye.wl.decadent.org.uk>
 <20140222092425.GA27897@dhcp-26-207.brq.redhat.com>
In-Reply-To: <20140222092425.GA27897@dhcp-26-207.brq.redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7356 signatures=668943
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1402220091
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: Alexander Gordeev [mailto:agordeev@redhat.com]
> Sent: Saturday, February 22, 2014 2:54 PM
> To: Ben Hutchings
> Cc: linux-kernel; Himanshu Madhani; Rajesh Borundia; Shahed Shaikh; Dept-
> Eng Linux Driver; netdev; linux-pci
> Subject: Re: [PATCH net-next 28/35] qlcnic: Use pci_enable_msix_range()
> instead of pci_enable_msix()
> 
> On Sat, Feb 22, 2014 at 12:48:47AM +0000, Ben Hutchings wrote:
> > Sorry, I'm confused and this does work.  But I wonder whether it is
> > really an improvement over using the old API.
> 
> Slightly, as far as I am concerned - we just exchange tri-state oddity to re-
> enable MSI-X oddity. We're not going to improve drivers that can not work
> with any number of MSI-Xs from a range, like this one.

I will send a patch which will make use of available MSI-X number and remove the retry logic.

Thanks,
Shahed
