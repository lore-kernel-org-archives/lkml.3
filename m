Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728AbaKIWoF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Nov 2014 17:44:05 -0500
Received: from SpacedOut.fries.net ([67.64.210.234]:50646 "EHLO
	SpacedOut.fries.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaKIWoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Nov 2014 17:44:03 -0500
X-Greylist: delayed 388 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Nov 2014 17:44:03 EST
From: David Fries <David@Fries.net>
To: linux-kernel@vger.kernel.org
Cc: Evgeniy Polyakov <zbr@ioremap.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: [PATHC 0/2] cn: w1: buffer size checks
Date: Sun,  9 Nov 2014 16:37:12 -0600
Message-Id: <1415572634-12303-1-git-send-email-David@Fries.net>
X-Mailer: git-send-email 1.7.10.4
X-Greylist: Sender passed SPF test, not delayed by milter-greylist-4.3.9 (SpacedOut.fries.net [127.0.0.1]); Sun, 09 Nov 2014 16:37:21 -0600 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These issues were found by Dan Carpenter with a static checker.
Evgeniy are you okay with these?

[PATCH 1/2] cn: verify msg->len before making callback
[PATCH 2/2] w1: avoid potential u16 overflow
