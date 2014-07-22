Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756816AbaGVUJC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 16:09:02 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:45551 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756772AbaGVUJA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 16:09:00 -0400
X-Originating-IP: 78.210.48.61
From: Guillaume Clement <gclement@baobob.org>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/5] staging: vt6655: fix sparse issues
Date: Tue, 22 Jul 2014 22:08:25 +0200
Message-Id: <1406059710-30903-1-git-send-email-gclement@baobob.org>
X-Mailer: git-send-email 1.8.5.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those patches fix warnings reported by sparse on the vt6655
driver. This will allow to more easily find real errors with sparse
later if one appears.


Note that checkpatch does return an error for patch 1 and 2 (line over
80 characters) but the line length was not increased by this patch. If
needed, I can do another patch set to fix the 80 column warnings too.

[PATCH 1/5] staging: vt6655: change type of PortOffset to void
[PATCH 2/5] staging: vt6655:fix warning for unexported non-static
[PATCH 3/5] staging: vt6655: statify some variables
[PATCH 4/5] staging: vt6655: remove unused functions
[PATCH 5/5] staging: vt6655: Fix unused function warning
