Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaICHXU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 03:23:20 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:22669 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755219AbaICHXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 03:23:18 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-c7-5406c1df53c8
From: Dmitry Kasatkin <d.kasatkin@samsung.com>
To: zohar@linux.vnet.ibm.com, linux-ima-devel@lists.sourceforge.net,
        linux-security-module@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, dmitry.kasatkin@gmail.com,
        Dmitry Kasatkin <d.kasatkin@samsung.com>
Subject: [PATCH 0/8] integrity: miscellaneous cleanups
Date: Wed, 03 Sep 2014 10:19:53 +0300
Message-id: <cover.1409728712.git.d.kasatkin@samsung.com>
X-Mailer: git-send-email 1.9.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBJMWRmVeSWpSXmKPExsVy+t/xq7r3D7KFGLy6y2Jx6+9eZosvS+ss
	Xs6Yx25xedccNosPPY/YLD6tmMTswOaxc9Zddo8HhzazeOxe8JnJo2/LKkaPz5vkAlijuGxS
	UnMyy1KL9O0SuDIuntjFWtDCUdF3ZwVrA+N+ti5GTg4JAROJVcs3skPYYhIX7q0HinNxCAks
	ZZSYfriVGcLpZJLo2PuHCaSKTUBPYkPzD7AOEYEciUlnLjCD2MwC6RKfJvWCxYUFzCQmHugC
	q2cRUJVYuqALLM4rYClx9cNCVohtchInj01mncDIvYCRYRWjaGppckFxUnquoV5xYm5xaV66
	XnJ+7iZGSGh82cG4+JjVIUYBDkYlHt4CNbYQIdbEsuLK3EOMEhzMSiK8volAId6UxMqq1KL8
	+KLSnNTiQ4xMHJxSDYzL4+7Vyyhfe1mscndDZfCywlbJXz+CZpWJFbf5PpN5mZs/9fLWeV2t
	d6+tW7bvk/31t9J33+Z5rWGyEth7wVEwuu+R/vq23vIFmk9f+qhmrOGPsyvbuqvfLZ7/6GT+
	6VXulmfM+QJU/u4SO73iscJd4ZLU43MiHed4ml5hS/l3dP2itz/87ucpsRRnJBpqMRcVJwIA
	LvzHX+sBAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is a few miscellaneous cleanups to improve code quality,
performance and prevent unnecessary memory allocations.

- Dmitry

Dmitry Kasatkin (8):
  integrity: prevent flooding with 'Request for unknown key'
  integrity: remove declaration of non-existing functions
  ima: simplify conditional statement to improve performance
  ima: remove unnecessary extra variable
  ima: add missing '__init' keywords
  ima: remove unnecessary code
  ima: remove usage of filename parameter
  ima: initialize only required template

 security/integrity/digsig_asymmetric.c |  5 +++--
 security/integrity/ima/ima.h           | 11 -----------
 security/integrity/ima/ima_appraise.c  |  2 --
 security/integrity/ima/ima_crypto.c    |  2 +-
 security/integrity/ima/ima_main.c      | 34 +++++++++++++++-------------------
 security/integrity/ima/ima_template.c  | 30 +++++-------------------------
 security/integrity/integrity.h         |  1 -
 7 files changed, 24 insertions(+), 61 deletions(-)

-- 
1.9.1

