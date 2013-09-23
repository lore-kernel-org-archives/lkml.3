Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906Ab3IWUGP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 16:06:15 -0400
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52829 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752341Ab3IWUGO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 16:06:14 -0400
X-Greylist: delayed 1529 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Sep 2013 16:06:13 EDT
From: Bing Zhao <bzhao@marvell.com>
To: Peter Senna Tschudin <peter.senna@gmail.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Date: Mon, 23 Sep 2013 12:40:33 -0700
Subject: RE: [PATCH 11/19] wireless: Change variable type to bool
Thread-Topic: [PATCH 11/19] wireless: Change variable type to bool
Thread-Index: Ac63GffMCkIpG2XXRFieAiDP/CLCWQBeqp7Q
Message-ID: <477F20668A386D41ADCC57781B1F70430F44C59426@SC-VEXCH1.marvell.com>
References: <1379802471-30252-1-git-send-email-peter.senna@gmail.com>
 <1379802471-30252-11-git-send-email-peter.senna@gmail.com>
In-Reply-To: <1379802471-30252-11-git-send-email-peter.senna@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-09-23_03:2013-09-22,2013-09-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1309230106
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

Thanks for your patch.

> The variables cancel_scan_cmd, enable_data, hs_activate and valid are
> only assigned the values true and false. Change its type to bool.
> 
> The simplified semantic patch that find this problem is as
> follows (http://coccinelle.lip6.fr/):
> 
> @exists@
> type T;
> identifier b;
> @@
> - T
> + bool
>   b = ...;
>   ... when any
>   b = \(true\|false\)
> 
> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>

Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

> ---
>  drivers/net/wireless/mwifiex/cmdevt.c  | 2 +-
>  drivers/net/wireless/mwifiex/join.c    | 2 +-
>  drivers/net/wireless/mwifiex/sta_cmd.c | 2 +-
>  drivers/net/wireless/mwifiex/wmm.c     | 2 +-
>  4 files changed, 4 insertions(+), 4 deletions(-)


