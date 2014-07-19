Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760795AbaGSJzw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 05:55:52 -0400
Received: from mail-we0-f169.google.com ([74.125.82.169]:43587 "EHLO
	mail-we0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760662AbaGSJzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 05:55:51 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        paul.gortmaker@windriver.com, jg1.han@samsung.com,
        paulmck@linux.vnet.ibm.com, valentina.manea.m@gmail.com, jack@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Fix issues reported by checkpatch
Date: Sat, 19 Jul 2014 11:55:39 +0200
Message-Id: <1405763743-30023-1-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

The drivers/staging/sep/sep_main.c have lots of checkpatch issue.
This patch series solves them and since there are many, I have splitted corrections in 4 patch.

Note that this work is done for the Eudyptulla Challenge.

Best regards

