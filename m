Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753488AbaKMBH4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:07:56 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52688 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752462AbaKMBHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:07:55 -0500
Date: Thu, 13 Nov 2014 09:04:52 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: David Miller <davem@davemloft.net>
CC: "antoine.tenart@free-electrons.com" 
	<antoine.tenart@free-electrons.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] net: pxa168_eth: move SET_NETDEV_DEV a bit earlier
Message-ID: <20141113090452.635b4fa0@xhacker>
In-Reply-To: <20141112.150810.806933062338696000.davem@davemloft.net>
References: <1415790527-6494-1-git-send-email-jszhang@marvell.com>
	<20141112.150810.806933062338696000.davem@davemloft.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.13.68,1.0.28,0.0.0000
 definitions=2014-11-13_01:2014-11-12,2014-11-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411130007
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear David,

On Wed, 12 Nov 2014 12:08:10 -0800
David Miller <davem@davemloft.net> wrote:

> From: Jisheng Zhang <jszhang@marvell.com>
> Date: Wed, 12 Nov 2014 19:08:47 +0800
> 
> > This is to ensure the net_device's dev.parent is set before we used it
> > in dma_zalloc_coherent() from init_hash_table().
> > 
> > Signed-off-by: Jisheng Zhang <jszhang@marvell.com>
> 
> Please always be explicit about what tree you generated this patch against
> and therefore expect it to be applied to by saying "[PATCH net-next]" or
> similar in your Subject line.

Got it. I will take care next time.

Thanks a lot
