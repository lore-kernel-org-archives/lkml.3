Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab3IYXk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 19:40:29 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:37171 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751833Ab3IYXk2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 19:40:28 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC: "David S. Miller" <davem@davemloft.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 25 Sep 2013 16:13:32 -0700
Subject: RE: [PATCH 09/11] mwifiex: Remove extern from function prototypes
Thread-Topic: [PATCH 09/11] mwifiex: Remove extern from function prototypes
Thread-Index: Ac66JtavKUWU8lBGQECLWO7X5JlNrgAHdtcw
Message-ID: <477F20668A386D41ADCC57781B1F70430F45077E54@SC-VEXCH1.marvell.com>
References: <cover.1380137609.git.joe@perches.com>
 <b3a7cd194857b3dc099e8f8bb0ed97bb4a1b5fde.1380137610.git.joe@perches.com>
In-Reply-To: <b3a7cd194857b3dc099e8f8bb0ed97bb4a1b5fde.1380137610.git.joe@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-09-25_12:2013-09-26,2013-09-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1309250141
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Joe,

Thanks for your patch.

> There are a mix of function prototypes with and without extern
> in the kernel sources.  Standardize on not using extern for
> function prototypes.
> 
> Function prototypes don't need to be written with extern.
> extern is assumed by the compiler.  Its use is as unnecessary as
> using auto to declare automatic/local variables in a block.
> 
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/wmm.h | 24 ++++++++++--------------
>  1 file changed, 10 insertions(+), 14 deletions(-)

