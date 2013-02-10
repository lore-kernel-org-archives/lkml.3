Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752626Ab3BJIKn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2013 03:10:43 -0500
Received: from mail-vb0-f43.google.com ([209.85.212.43]:61139 "EHLO
	mail-vb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752240Ab3BJIKl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2013 03:10:41 -0500
From: Len Brown <lenb@kernel.org>
To: linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Two x86 idle cleanups
Date: Sun, 10 Feb 2013 03:10:27 -0500
Message-Id: <1360483829-16349-1-git-send-email-lenb@kernel.org>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following two patches remove cruft from the x86 native idle code.
These two removals have been marked with a WARN() since Linux 3.0.

Let me know if you see any troubles w/ these patches.

TIP,
These will conflict with another patch in my tree.
So if you approve, please Ack and I can carry in my tree.

thanks,
Len Brown, Intel Open Source Technology Center

