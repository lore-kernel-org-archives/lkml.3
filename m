Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754939AbaAHDEu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 22:04:50 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:52227 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753994AbaAHDEi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 22:04:38 -0500
From: Bing Zhao <bzhao@marvell.com>
To: Ding Tianhong <dingtianhong@huawei.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Tue, 7 Jan 2014 19:04:15 -0800
Subject: RE: [PATCH v3.6 17/19] mwifiex: slight optimization of addr compare
Thread-Topic: [PATCH v3.6 17/19] mwifiex: slight optimization of addr compare
Thread-Index: Ac8MHQa83mjO/JfWR4O47h5pAsgAzgAALu9w
Message-ID: <477F20668A386D41ADCC57781B1F70430F534B5550@SC-VEXCH1.marvell.com>
References: <52CCBDDC.1050503@huawei.com>
In-Reply-To: <52CCBDDC.1050503@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-01-08_01:2014-01-07,2014-01-08,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1401070202
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s08351ca023184

Hi Ding,

> -	if (memcmp(priv->curr_bss_params.bss_descriptor.mac_address,
> -		   ibss_coal_resp->bssid, ETH_ALEN)) {
> +	if (!ether_addr_equal(priv->curr_bss_params.bss_descriptor.mac_address, ibss_coal_resp->bssid))

Still wrong... ;)

Have you actually run the checkpatch.pl script?

By the way, your subject prefix "PATCH v3.6" is confusing. It ought to be "PATCH v6", I guess.

Thanks,
Bing

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
