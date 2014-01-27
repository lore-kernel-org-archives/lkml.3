Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbaA0Rq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 12:46:56 -0500
Received: from mail-we0-f176.google.com ([74.125.82.176]:42292 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753719AbaA0Rqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 12:46:55 -0500
From: Luis Ortega <luiorpe1@upv.es>
To: dmitry.torokhov@gmail.com
Cc: heiko@sntech.de, yongjun_wei@trendmicro.com.cn,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Input: zforce - fix various small issues
Date: Mon, 27 Jan 2014 19:46:09 +0100
Message-Id: <1390848373-7723-1-git-send-email-luiorpe1@upv.es>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As a kernel newbie and owner of a Barnes & Noble e-reader I was
curious to review this driver to learn more about the touchscreen.

The first two patches are fairly innocuous whereas the last two
slightly modify the code to fix two small issues I discovered.
I don't have the setup to test them but they look logically correct
to me.

[PATCH 1/4] Input: zforce - fix spelling errors
[PATCH 2/4] Input: zforce - fix lines exceeding 80 columns
[PATCH 3/4] Input: zforce - Remove unnecessary payload data checks
[PATCH 4/4] Input: zforce - reduce stack memory allocated to frames
