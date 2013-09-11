Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755653Ab3IKS6U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 14:58:20 -0400
Received: from usindpps04.hds.com ([207.126.252.17]:44581 "EHLO
	usindpps04.hds.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab3IKS6T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 14:58:19 -0400
From: Seiji Aguchi <seiji.aguchi@hds.com>
To: "Luck, Tony" <tony.luck@intel.com>,
        Aruna Balakrishnaiah <aruna@linux.vnet.ibm.com>,
        "linuxppc-dev@ozlabs.org" <linuxppc-dev@ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "keescook@chromium.org" <keescook@chromium.org>
CC: "jkenisto@linux.vnet.ibm.com" <jkenisto@linux.vnet.ibm.com>,
        "mahesh@linux.vnet.ibm.com" <mahesh@linux.vnet.ibm.com>,
        "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "ccross@android.com" <ccross@android.com>
Subject: RE: [PATCH 1/3] pstore: Adjust buffer size for compression for
 smaller registered buffers
Thread-Topic: [PATCH 1/3] pstore: Adjust buffer size for compression for
 smaller registered buffers
Thread-Index: AQHOrud4p7DFLR6o7UGHQSPdRhVeD5nBIHyA///AJAA=
Date: Wed, 11 Sep 2013 18:57:54 +0000
Message-ID: <A5ED84D3BB3A384992CBB9C77DEDA4D443EC2753@USINDEM103.corp.hds.com>
References: <20130911120639.27730.8671.stgit@aruna-ThinkPad-T420>
 <3908561D78D1C84285E8C5FCA982C28F31CF4C85@ORSMSX106.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F31CF4C85@ORSMSX106.amr.corp.intel.com>
Accept-Language: ja-JP, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.74.73.11]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-SPF-Result: pass
X-Proofpoint-SPF-Record: v=spf1 mx ip4:207.126.244.0/26 ip4:207.126.252.0/25 include:mktomail.com
 include:cloud.hds.com ~all
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.10.8794,1.0.431,0.0.0000
 definitions=2013-09-11_06:2013-09-11,2013-09-11,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=outbound_policy score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1309110108
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r8BIwQSu007152

>+	/* buffer range for efivars */
>+	case 1000 ... 2000:
>+		cmpr = 56;
>+		break;

> Seiji: let me know how the efivars tests go.

efivars works fine.
Uncompressed size about 1800 bytes. It matches the value of cmpr, 56. 

Please feel free to add my "Tested-by" to all three patches.

Tested-by: Seiji Aguchi <seiji.aguchi@hds.com>

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
