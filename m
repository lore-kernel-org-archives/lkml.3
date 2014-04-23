Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbaDWCqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 22:46:07 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:64625 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754754AbaDWCqF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 22:46:05 -0400
Date: Wed, 23 Apr 2014 10:43:43 +0800
From: Jisheng Zhang <jszhang@marvell.com>
To: Antoine =?UTF-8?B?VMOpbmFydA==?= 
	<antoine.tenart@free-electrons.com>
CC: "sebastian.hesselbarth@gmail.com" <sebastian.hesselbarth@gmail.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "alexandre.belloni@free-electrons.com" 
	<alexandre.belloni@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 6/6] ARM: berlin: add the AHCI node for the BG2CD
Message-ID: <20140423104343.45979ab0@xhacker>
In-Reply-To: <1398181105-19714-7-git-send-email-antoine.tenart@free-electrons.com>
References: <1398181105-19714-1-git-send-email-antoine.tenart@free-electrons.com>
	<1398181105-19714-7-git-send-email-antoine.tenart@free-electrons.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.96,1.0.14,0.0.0000
 definitions=2014-04-23_01:2014-04-22,2014-04-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=2
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1404230051
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Antoine,

On Tue, 22 Apr 2014 08:38:25 -0700
Antoine Ténart <antoine.tenart@free-electrons.com> wrote:

> The BG2CD has an AHCI SATA controller. Add the corresponding node
> in its device tree.

BG2CD doesn't has AHCI controller. 

Thanks
