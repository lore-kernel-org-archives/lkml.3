Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210AbaDNOrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 10:47:07 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:62189 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151AbaDNOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 10:47:04 -0400
From: minyard@acm.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        OpenIPMI Developers <openipmi-developer@lists.sourceforge.net>
Subject: [PATCH 0/7] ipmi: a bunch of small fixes
Date: Mon, 14 Apr 2014 09:46:49 -0500
Message-Id: <1397486816-18045-1-git-send-email-minyard@acm.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Things collected since last kernel release.

Some of these are pretty important.  The first three are bug fixes.  The
next three are to hopefully make everyone happy about allowing ACPI to
be on all the time and not have IPMI have an effect on the system when
not in use.  The last is a little cleanup.

-corey
