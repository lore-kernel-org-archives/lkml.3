Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752807AbaCLMrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 08:47:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:4246 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751575AbaCLMrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 08:47:05 -0400
Date: Wed, 12 Mar 2014 20:44:54 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>,
        "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "Jimmy Xu" <zmxu@marvell.com>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 2/2] ARM: dts: berlin2q: add the Marvell BG2-Q DMP
 device tree
Message-ID: <20140312204454.36a6be85@xhacker>
In-Reply-To: <20140312123759.GB15090@lunn.ch>
References: <1394622364-6848-1-git-send-email-antoine.tenart@free-electrons.com>
	<1394622364-6848-3-git-send-email-antoine.tenart@free-electrons.com>
	<20140312200428.23178d69@xhacker>
	<20140312123759.GB15090@lunn.ch>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-12_04:2014-03-12,2014-03-12,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1403120046
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andrew,

On Wed, 12 Mar 2014 05:37:59 -0700
Andrew Lunn <andrew@lunn.ch> wrote:

> > > +/dts-v1/;
> > > +#include "berlin2q.dtsi"
> > > +
> > > +/ {
> > > +	model = "Marvell BG2-Q DMP";
> > > +	compatible = "marvell,berlin2q-dmp", "marvell,berlin2q",
> > > "marvell,berlin"; +
> > > +	memory {
> > > +		device_type = "memory";
> > > +		reg = <0x00000000 0x40000000>;
> > 
> > The memory size of BG2Q DMP is 2GB.
> 
> Jisheng
> 
> Does this imply that the RAM is inside the SoC package, and that
> there is no external memory interface which can be used to add more
> RAM?

Nope. The ram is on the board. After talking with Alex, I think it's 
reasonable to put the memory node in dts as the original patch does.

However, we need to set the correct memory size of BG2Q DMP board.

Thanks,
Jisheng

