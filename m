Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949AbbAGJkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2015 04:40:06 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:35594 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005AbbAGJkD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2015 04:40:03 -0500
From: Fabian Holler <fabian.holler@profitbricks.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Fabian Holler <fabian.holler@profitbricks.com>
Subject: [PATCH 0/3] staging: android: fix checkpatch warnings in ashmem.c
Date: Wed,  7 Jan 2015 10:39:51 +0100
Message-Id: <cover.1420622282.git.fabian.holler@profitbricks.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

this patchset fixes the checkpatch.pl warnings in
drivers/staging/android/ashmem.c

regards

Fabian

Fabian Holler (3):
  staging: android: fix indentation to match open parenthesis
  staging: android: remove unnecessary blank lines after open brace
  staging: android: remove unnecessary space after cast

 drivers/staging/android/ashmem.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

-- 
2.1.3

