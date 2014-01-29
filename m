Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087AbaA2EDF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 23:03:05 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:61292 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560AbaA2EDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 23:03:03 -0500
From: Manish Badarkhe <badarkhe.manish@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: gregkh@linuxfoundation.org, broonie@kernel.org, lgirdwood@gmail.com,
        badarkhe.manish@gmail.com
Subject: [PATCH V3 0/2] devm_* API operation for fixed regulator
Date: Wed, 29 Jan 2014 09:32:59 +0530
Message-Id: <1390968181-31800-1-git-send-email-badarkhe.manish@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use devm_* API operations for fixed regulator driver so that
driver core will manage resources.

Also, introduce a new API "devm_kstrdup" and used it in fixed
regulator driver to manage resources.

Changes since V2:
 1. Update driver to use new API "devm_kstrdup" instead of
    "kstrdup".
 2. Added a seperate patch to introduce new API "devm_kstrdup"

Changes since V1:
 1. Updated driver to use "devm_kzalloc" instead of "kstrdup".
 2. Updated commit message.

Manish Badarkhe (2):
  devres: introduce API "devm_kstrdup"
  regulator: fixed: update to devm_* API

 drivers/base/devres.c     |   26 ++++++++++++++++++++++++++
 drivers/regulator/fixed.c |   44 ++++++++++++++------------------------------
 include/linux/device.h    |    2 ++
 3 files changed, 42 insertions(+), 30 deletions(-)

-- 
1.7.10.4

