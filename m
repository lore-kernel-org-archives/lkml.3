Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750975AbaKBFrU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Nov 2014 01:47:20 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:8785 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750745AbaKBFrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Nov 2014 01:47:18 -0400
Date: Sun, 2 Nov 2014 13:44:16 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Jason Cooper <jason@lakedaemon.net>
CC: "tglx@linutronix.de" <tglx@linutronix.de>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] irqchip: dw-apb-ictl: select GENERIC_IRQ_CHIP
Message-ID: <20141102134416.1679e632@xhacker>
In-Reply-To: <20141102022311.GS3698@titan.lakedaemon.net>
References: <1413982750-832-1-git-send-email-jszhang@marvell.com>
	<20141102022311.GS3698@titan.lakedaemon.net>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.28,0.0.0000
 definitions=2014-11-02_02:2014-10-31,2014-11-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1411020063
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 1 Nov 2014 19:23:11 -0700
Jason Cooper <jason@lakedaemon.net> wrote:

> Jisheng,
> 
> On Wed, Oct 22, 2014 at 08:59:10PM +0800, Jisheng Zhang wrote:
> > The dw-apb-ictl driver uses the generic-chip functions.
> > Thus it needs to select GENERIC_IRQ_CHIP in Kconfig.
> > 
> > Change-Id: If748beffc4e0d0b47062bb067a59c10994a9148b
> 
> Please don't include this is future patches.

oops, sorry for my fault. I'll take care from now on.

Thanks for kindly reminding,
Jisheng
