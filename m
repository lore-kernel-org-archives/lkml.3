Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753931AbaFCIFR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 04:05:17 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:47335 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753817AbaFCIFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 04:05:08 -0400
Date: Tue, 3 Jun 2014 16:02:39 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "thomas.petazzoni@free-electrons.com" 
	<thomas.petazzoni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/5] ARM: berlin: add SMP support
Message-ID: <20140603160239.38defafe@xhacker>
In-Reply-To: <20140603075011.GA22742@lunn.ch>
References: <1401700866-24804-1-git-send-email-antoine.tenart@free-electrons.com>
	<1401700866-24804-2-git-send-email-antoine.tenart@free-electrons.com>
	<20140602094715.GG28090@lunn.ch>
	<20140602100048.GA12162@kwain>
	<20140602100332.GH28090@lunn.ch>
	<20140602102750.GB13681@kwain>
	<20140603141913.710a1f7e@xhacker>
	<20140603075011.GA22742@lunn.ch>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.14,0.0.0000
 definitions=2014-06-02_03:2014-06-02,2014-06-02,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1406030102
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Tue, 3 Jun 2014 00:50:11 -0700
Andrew Lunn <andrew@lunn.ch> wrote:

> > We don't support independently power off cpu on BG2 and BG2Q in linux
> > kernel. So we can assume that bootloader has powered on the CPUs
> 
> Can i assume from your answer that the hardware does actually support
> independent power off/on of CPUs? It could be added sometime in the
> future.
> 

The BG2 and BG2Q HW doesn't support independent power off/on CPUs.

Sorry for confusion,
Jisheng
