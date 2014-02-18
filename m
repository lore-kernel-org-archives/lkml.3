Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752257AbaBRTUx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:20:53 -0500
Received: from mx0b-0016ce01.pphosted.com ([67.231.156.153]:10823 "EHLO
	mx0b-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751454AbaBRTUv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:20:51 -0500
From: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
To: Alexander Gordeev <agordeev@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
CC: Shahed Shaikh <shahed.shaikh@qlogic.com>,
        Ron Mercer <ron.mercer@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>, linux-pci <linux-pci@vger.kernel.org>
Subject: Re: [PATCH net-next 30/35] qlge: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Thread-Topic: [PATCH net-next 30/35] qlge: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Thread-Index: AQHPLJHA29/dhqlyiEKmmGXihQ6RLpq7Y+YA
Date: Tue, 18 Feb 2014 19:20:46 +0000
Message-ID: <BECD8E8A1B550B48A1BF97C13991F60E46D21C7E@avmb2.qlogic.org>
References: <cover.1392717502.git.agordeev@redhat.com>
 <443a0172bc2fe0aa92fca6044d7374475e2ad4c1.1392717503.git.agordeev@redhat.com>
In-Reply-To: <443a0172bc2fe0aa92fca6044d7374475e2ad4c1.1392717503.git.agordeev@redhat.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Microsoft-MacOutlook/14.3.9.131030
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="us-ascii"
Content-ID: <7DE3D9FC4C038C4BACC636F4083881EA@qlogic.com>
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7353 signatures=668936
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1402180127
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 2/18/14 2:11 AM, "Alexander Gordeev" <agordeev@redhat.com> wrote:

>As result of deprecation of MSI-X/MSI enablement functions
>pci_enable_msix() and pci_enable_msi_block() all drivers
>using these two interfaces need to be updated to use the
>new pci_enable_msi_range() and pci_enable_msix_range()
>interfaces.
>
>Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
>Cc: Shahed Shaikh <shahed.shaikh@qlogic.com>
>Cc: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>
>Cc: Ron Mercer <ron.mercer@qlogic.com>
>Cc: linux-driver@qlogic.com
>Cc: netdev@vger.kernel.org
>Cc: linux-pci@vger.kernel.org
>---
> drivers/net/ethernet/qlogic/qlge/qlge_main.c |   15 ++++-----------
> 1 files changed, 4 insertions(+), 11 deletions(-)

Acked-by: Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>

