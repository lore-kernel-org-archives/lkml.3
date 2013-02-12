Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758752Ab3BLXGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 18:06:49 -0500
Received: from mail-we0-f171.google.com ([74.125.82.171]:46765 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754896Ab3BLXGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:06:47 -0500
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: [PATCH v3 0/5] of: Add helper for counting phandle refernces
Date: Tue, 12 Feb 2013 23:06:36 +0000
Message-Id: <1360710401-16757-1-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, this started as a single patch to get rid of horrible brute-force
counting of phandles and ended with fixes to the selftest code and
cleanups to the existing phandle parser before actually getting to the
new feature.

The selftest code is still a little fiddly to execute, but at least it
is consistent now. Sometime soon I'll link the selftest data directly
into the kernel so nothing special has to be done to run it, but I think
the DT grafting support needs to go in first.

