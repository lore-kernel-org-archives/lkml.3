Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368AbaGIGao (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 02:30:44 -0400
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:30727 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751054AbaGIGam convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 02:30:42 -0400
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: ethan zhao <ethan.zhao@oracle.com>, David Miller <davem@davemloft.net>
CC: "balbi@ti.com" <balbi@ti.com>, netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "sriharsha.devdas@oracle.com" <sriharsha.devdas@oracle.com>,
        "ethan.kernel@gmail.com" <ethan.kernel@gmail.com>,
        "vaughan.cao@oracle.com" <vaughan.cao@oracle.com>
Subject: RE: [PATCH NET-NEXT V2] netxen: fix ethtool rx_dropped information
 in ethtool get_ethtool_stats()
Thread-Topic: [PATCH NET-NEXT V2] netxen: fix ethtool rx_dropped information
 in ethtool get_ethtool_stats()
Thread-Index: AQHPmx9Vu62qlgYRQU+Yxv8I749zLZuXj7UAgAAY64D//55qYA==
Date: Wed, 9 Jul 2014 06:30:36 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A46FEEF8B@avmb2.qlogic.org>
References: <1404827830-22990-1-git-send-email-ethan.zhao@oracle.com>
 <53BCABD3.3050207@oracle.com>
 <20140708.204602.1475610247455018529.davem@davemloft.net>
 <53BCCFE1.5000806@oracle.com>
In-Reply-To: <53BCCFE1.5000806@oracle.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7493 signatures=670477
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1407090090
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: netdev-owner@vger.kernel.org [mailto:netdev-
> owner@vger.kernel.org] On Behalf Of ethan zhao
> Sent: Wednesday, July 09, 2014 10:45 AM
> To: David Miller
> Cc: balbi@ti.com; netdev; linux-kernel; sriharsha.devdas@oracle.com;
> ethan.kernel@gmail.com; vaughan.cao@oracle.com
> Subject: Re: [PATCH NET-NEXT V2] netxen: fix ethtool rx_dropped
> information in ethtool get_ethtool_stats()
> 
> David,
>      Sorry I don't know who owns this driver, the SOB of other patches to
> netxen may mislead me you could ACK it or not,  so it is definitely not the
> original meaning that ask you specifically to review one patch.
> just ask for help point to someone could review it

Ethan,

You can get the maintainers of netxen_nic driver from " MAINTAINERS" file.
Please copy maintainers of this driver for review.

NETXEN (1/10) GbE SUPPORT
M:      Manish Chopra <manish.chopra@qlogic.com>
M:      Sony Chacko <sony.chacko@qlogic.com>
M:      Rajesh Borundia <rajesh.borundia@qlogic.com>
L:      netdev@vger.kernel.org
W:      http://www.qlogic.com
S:      Supported
F:      drivers/net/ethernet/qlogic/netxen/


HTH.

Thanks,
Shahed
