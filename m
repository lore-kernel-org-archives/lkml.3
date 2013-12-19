Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab3LSLvV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:51:21 -0500
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:32513 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752438Ab3LSLvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:51:19 -0500
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: Rashika Kheria <rashika.kheria@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@qlogic.com>,
        Rajesh Borundia <rajesh.borundia@qlogic.com>,
        Jitendra Kalsaria <jitendra.kalsaria@qlogic.com>,
        Sony Chacko <sony.chacko@qlogic.com>,
        Sucheta Chakraborty <sucheta.chakraborty@qlogic.com>,
        Dept-Eng Linux Driver <Linux-Driver@qlogic.com>,
        netdev <netdev@vger.kernel.org>,
        "josh@joshtriplett.org" <josh@joshtriplett.org>
Subject: RE: [PATCH v3 2/8] drivers: net: Mark functions as static in
 qlcnic_83xx_hw.c
Thread-Topic: [PATCH v3 2/8] drivers: net: Mark functions as static in
 qlcnic_83xx_hw.c
Thread-Index: AQHO/JcgVX1oMlM+F0eXQ5ihYwVKeppbZ9Ow
Date: Thu, 19 Dec 2013 11:51:13 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A46F49D4B@avmb2.qlogic.org>
References: <04fe932bc3585620c91d511bb0894e45bb762ffa.1387382457.git.rashika.kheria@gmail.com>
 <e50a81d6fd512838c98cd46a0ce66262da5cf811.1387382457.git.rashika.kheria@gmail.com>
In-Reply-To: <e50a81d6fd512838c98cd46a0ce66262da5cf811.1387382457.git.rashika.kheria@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7293 signatures=668857
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1305240000 definitions=main-1312190040
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id rBJExuHg003016

> -----Original Message-----
> From: Rashika Kheria [mailto:rashika.kheria@gmail.com]
> Sent: Thursday, December 19, 2013 2:18 PM
> To: linux-kernel; Himanshu Madhani; Rajesh Borundia; Shahed Shaikh;
> Jitendra Kalsaria; Sony Chacko; Sucheta Chakraborty; Dept-Eng Linux Driver;
> netdev; josh@joshtriplett.org
> Subject: [PATCH v3 2/8] drivers: net: Mark functions as static in
> qlcnic_83xx_hw.c
> 
> This patch marks the function qlcnic_83xx_clear_legacy_intr_mask(),
> qlcnic_83xx_set_legacy_intr_mask() and
> qlcnic_83xx_enable_legacy_msix_mbx_intr() in qlcnic_83xx_hw.c as static
> because they are not used outside this file.
> 
> Thus, it also removes the following warnings in
> ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:
> 
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:318:13: warning: no
> previous prototype for â€˜qlcnic_83xx_clear_legacy_intr_maskâ€™ [-Wmissing-
> prototypes]
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:323:13: warning: no
> previous prototype for â€˜qlcnic_83xx_set_legacy_intr_maskâ€™ [-Wmissing-
> prototypes]
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_83xx_hw.c:343:13: warning: no
> previous prototype for â€˜qlcnic_83xx_enable_legacy_msix_mbx_intrâ€™ [-
> Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>
> Reviewed-by: Josh Triplett <josh@joshtriplett.org>

Acked-by: Shahed Shaikh <shahed.shaikh@qlogic.com>

Thanks,
Shahed
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
