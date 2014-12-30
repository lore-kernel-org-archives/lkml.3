Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075AbaL3Ipt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 03:45:49 -0500
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:25679 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751838AbaL3Ipr convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 03:45:47 -0500
From: Shahed Shaikh <shahed.shaikh@qlogic.com>
To: "xuyongjiande@163.com" <xuyongjiande@163.com>,
        Dept-GE Linux NIC Dev <Dept-GELinuxNICDev@qlogic.com>
CC: netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Yongjian Xu <xuyongjiande@gmail.com>
Subject: RE: [PATCH] qlcnic: Fix return value in qlcnic_probe()
Thread-Topic: [PATCH] qlcnic: Fix return value in qlcnic_probe()
Thread-Index: AQHQJAdkFyLMlrF+4Eunwxkt5oeMJZyn0V2Q
Date: Tue, 30 Dec 2014 08:45:36 +0000
Message-ID: <262CB373A6D1F14F9B81E82F74F77D5A4717C763@avmb2.qlogic.org>
References: <1419926626-26624-1-git-send-email-xuyongjiande@163.com>
In-Reply-To: <1419926626-26624-1-git-send-email-xuyongjiande@163.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.1.4.10]
disclaimer: bypass
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=nai engine=5600 definitions=7666 signatures=670598
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=7.0.1-1402240000 definitions=main-1412300090
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> -----Original Message-----
> From: xuyongjiande@163.com [mailto:xuyongjiande@163.com]
> Sent: Tuesday, December 30, 2014 1:34 PM
> To: Shahed Shaikh; Dept-GE Linux NIC Dev
> Cc: netdev; linux-kernel; Yongjian Xu
> Subject: [PATCH] qlcnic: Fix return value in qlcnic_probe()
> 
> From: Yongjian Xu <xuyongjiande@gmail.com>
> 
> If the check of adapter fails and goes into the 'else' branch, the return value
> 'err' should not still be zero.
> 
> Signed-off-by: Yongjian Xu <xuyongjiande@gmail.com>
> ---
>  drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c |    1 +
>  1 file changed, 1 insertion(+)

Acked-by: Shahed Shaikh <shahed.shaikh@qlogic.com>

Thanks,
Shahed
