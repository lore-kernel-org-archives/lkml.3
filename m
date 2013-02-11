Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab3BKULk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2013 15:11:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3364 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932253Ab3BKULi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2013 15:11:38 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: zohar@linux.vnet.ibm.com, linux-security-module@vger.kernel.org
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/2] ima: Support a mode to appraise signed files only
Date: Mon, 11 Feb 2013 15:11:31 -0500
Message-Id: <1360613493-11969-1-git-send-email-vgoyal@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mimi,

As we discussed, thhis is a RFC patch to extend current appraisal rules
to allow appraising signed files only. This should apply on top of
Dmitry's patches to support asymmetric key signatures.

Thanks
Vivek

Vivek Goyal (2):
  ima: Do not try to fix hash if file system does not support security
    xattr
  ima: Support appraise_type=imasig_optional

 Documentation/ABI/testing/ima_policy  |    2 +-
 security/integrity/ima/ima_appraise.c |   26 ++++++++++++++++++++++----
 security/integrity/ima/ima_policy.c   |    2 ++
 security/integrity/integrity.h        |    1 +
 4 files changed, 26 insertions(+), 5 deletions(-)

-- 
1.7.7.6

