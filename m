Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751235AbaDRGI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 02:08:58 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:5410 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751039AbaDRGIz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 02:08:55 -0400
Date: Fri, 18 Apr 2014 14:06:39 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "chris@printf.net" <chris@printf.net>,
        "anton@enomsg.org" <anton@enomsg.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/4] mmc: sdhci: add a driver for Berlin SoCs
Message-ID: <20140418140639.03c450f3@xhacker>
In-Reply-To: <20140417133359.GB31034@kwain>
References: <1397652011-21284-1-git-send-email-antoine.tenart@free-electrons.com>
	<1397652011-21284-2-git-send-email-antoine.tenart@free-electrons.com>
	<534E92FE.8010400@gmail.com>
	<20140417133359.GB31034@kwain>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-18_01:2014-04-17,2014-04-18,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404180106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 17 Apr 2014 06:33:59 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> Sebastian,
> 
> On Wed, Apr 16, 2014 at 04:26:06PM +0200, Sebastian Hesselbarth wrote:
> > On 04/16/2014 02:40 PM, Antoine Ténart wrote:
> > >Add a Driver to support the SDHCI controller of the Marvell Berlin SoCs.
> > >This controller supports 3 sockets.
> > 
> > nit: Isn't it three controller with one socket each?
> 
> It's a little bit confusing, there are 3 different register regions and
> I can see 3 separate data lines but, I quote: "The SD host controller
> supports three sockets".
> 
> Maybe Jisheng can advise on that matter ?


It's three controller with one socket each ;)

Thanks
