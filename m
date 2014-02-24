Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753142AbaBXIFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Feb 2014 03:05:55 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:14865 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752074AbaBXIDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Feb 2014 03:03:25 -0500
From: Neil Zhang <zhangwm@marvell.com>
To: <balbi@ti.com>, <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
CC: Neil Zhang <zhangwm@marvell.com>
Subject: [PATCH 0/6] bug fix for mv_udc_core.c
Date: Mon, 24 Feb 2014 16:03:10 +0800
Message-ID: <1393228996-14787-1-git-send-email-zhangwm@marvell.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-02-23_03:2014-02-21,2014-02-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=1 spamscore=1 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1402230265
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is mainly for bug fix.

Neil Zhang (6):
  usb: gadget: mv_udc: remove redundant pull up in udc_start
  usb: gadget: mv_udc: disable HW zlt for ep0
  usb: gadget: mv_udc: clear corresponding interrupt when flush fifo
  usb: gadget: mv_udc: check endpoint before queue dtd
  USB: gadget: mv_udc: workaroud for missing dTD
  USB: gadget: mv_udc: fix corner case for missiong dTD

 drivers/usb/gadget/mv_udc_core.c |   47 ++++++++++++++++++++++++++++++++++----
 1 file changed, 42 insertions(+), 5 deletions(-)

-- 
1.7.9.5

