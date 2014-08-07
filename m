Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755004AbaHGBwC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 21:52:02 -0400
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:25360 "EHLO
	mx0a-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754853AbaHGBv7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 21:51:59 -0400
From: Xiangliang Yu <yuxiangl@marvell.com>
To: Dan Williams <dan.j.williams@intel.com>
CC: "JBottomley@parallels.com" <JBottomley@parallels.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "todd.e.brandt@intel.com" <todd.e.brandt@intel.com>,
        "lukasz.dorau@intel.com" <lukasz.dorau@intel.com>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Wed, 6 Aug 2014 18:50:48 -0700
Subject: RE: [PATCH 1/3] libsas: modify SATA error handler
Thread-Topic: [PATCH 1/3] libsas: modify SATA error handler
Thread-Index: Ac+xmupyBztQPWHIQqeyq/TYNjNtLQARlxhw
Message-ID: <F766E4F80769BD478052FB6533FA745D5944CE8DCE@SC-VEXCH4.marvell.com>
References: <1398346047-10276-1-git-send-email-yxlraid@gmail.com>
	<CAP0P+NWxxxnQH1e3tXcqwud7EaV4kRRMW46Ad-PWoMWFzgy1eg@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D57320C6287@SC-VEXCH4.marvell.com>
	<CAPcyv4g7zMf4UGZPYFk30kh5J_-ot6kuesEjOZJTRbL_UkpQ9g@mail.gmail.com>
	<F766E4F80769BD478052FB6533FA745D5944CE8C71@SC-VEXCH4.marvell.com>
 <CAPcyv4jSr7O2Qxe-ac9anJUT4KksbdNuCGd=iBFy2CJF8G5Mkw@mail.gmail.com>
In-Reply-To: <CAPcyv4jSr7O2Qxe-ac9anJUT4KksbdNuCGd=iBFy2CJF8G5Mkw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.12.52,1.0.27,0.0.0000
 definitions=2014-08-07_01:2014-08-06,2014-08-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1402240000 definitions=main-1408070024
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id s771q5Pg014942

Hi, Dan
I haven't receive your review comments, could you send it to me again, thanks!
PS: I can't login my gmail, so please send mail to this count.


-----Original Message-----
From: Dan Williams [mailto:dan.j.williams@intel.com] 
Sent: 2014å¹´8æœˆ7æ—¥ 1:22
To: Xiangliang Yu
Cc: JBottomley@parallels.com; tj@kernel.org; todd.e.brandt@intel.com; lukasz.dorau@intel.com; linux-ide@vger.kernel.org; linux-kernel@vger.kernel.org; linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] libsas: modify SATA error handler

On Wed, Aug 6, 2014 at 3:50 AM, Xiangliang Yu <yuxiangl@marvell.com> wrote:
> Hi, Dan & James
> How about the patches about support for PM?
> Two months had passed since I submitted the patches.
> Thanks!
>

Did you address my review comments?
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
