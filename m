Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932378AbaGSReu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jul 2014 13:34:50 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:46901 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755317AbaGSRet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jul 2014 13:34:49 -0400
From: LABBE Corentin <clabbe.montjoie@gmail.com>
To: gregkh@linuxfoundation.org, monamagarwal123@gmail.com,
        paul.gortmaker@windriver.com, jg1.han@samsung.com,
        paulmck@linux.vnet.ibm.com, valentina.manea.m@gmail.com, jack@suse.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: sep: Fix issues reported by checkpatch
Date: Sat, 19 Jul 2014 19:34:38 +0200
Message-Id: <1405791282-28023-1-git-send-email-clabbe.montjoie@gmail.com>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

The drivers/staging/sep/sep_main.c have lots of checkpatch issue.
This patch series solves them and since there are many, I have splitted corrections in 4 patch.

Note that this work is done for the Eudyptulla Challenge.

Best regards

