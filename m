Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756378Ab3LTKhi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 05:37:38 -0500
Received: from faui40.informatik.uni-erlangen.de ([131.188.34.40]:36121 "EHLO
	faui40.informatik.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755861Ab3LTKhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 05:37:32 -0500
From: Andreas Frembs <andreas.frembs@studium.uni-erlangen.de>
To: andreas.frembs@studium.uni-erlangen.de
Cc: matthias.schoepe@studium.uni-erlangen.de, gregkh@linuxfoundation.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        linux-kernel@i4.cs.fau.de
Subject: [PATCH] rtl8192e: Fixing checkpatch errors and removing unused defines
Date: Fri, 20 Dec 2013 11:29:07 +0100
Message-Id: <1387535350-27442-1-git-send-email-andreas.frembs@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We fixed checkpatch errors in the rtl8192e driver and noticed that some
macros that produced errors in checkpatch are unused, so we removed them.
There are no functional changes in this patch.

