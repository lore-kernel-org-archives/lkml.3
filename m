Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934335Ab3JPMji (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 08:39:38 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:48305 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932406Ab3JPMjh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 08:39:37 -0400
From: Neil Zhang <zhangwm@marvell.com>
To: "rob.herring@calxeda.com" <rob.herring@calxeda.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Yu Tang <ytang5@marvell.com>, Zhou Zhu <zzhu3@marvell.com>
Date: Wed, 16 Oct 2013 05:39:32 -0700
Subject: [Question] Ask for arm arch timer
Thread-Topic: [Question] Ask for arm arch timer
Thread-Index: Ac7KbMOfrjv78kxwSFCt4Rke2/2frw==
Message-ID: <175CCF5F49938B4D99B2E3EF7F558EBE49FCEFF280@SC-VEXCH4.marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-10-16_03:2013-10-16,2013-10-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1310160034
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rob,
I saw your following patch called clocksource_of_init() directly in time_init() for arm64.
My question is that what should we do if there are some Soc special work need to be done before arch timer can be used?
Thanks in advance.

commit 0583fe478a7d93be2c814b7e50d6e81c287edfe8
Author: Rob Herring <rob.herring@calxeda.com>
Date:   Wed Apr 10 18:27:51 2013 -0500

    ARM: convert arm/arm64 arch timer to use CLKSRC_OF init


Best Regards,
Neil Zhang


