Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932154Ab3JNOud (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 10:50:33 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:33889 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932123Ab3JNOub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 10:50:31 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Tomi Valkeinen <tomi.valkeinen@ti.com>, Archit Taneja <archit@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the omap_dss2 tree
Date: Mon, 14 Oct 2013 16:48:06 +0200
Message-Id: <1381762088-18880-6-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.4
In-Reply-To: <1381762088-18880-1-git-send-email-treding@nvidia.com>
References: <1381762088-18880-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Today's linux-next merge of the omap_dss2 tree got conflicts in

	drivers/video/omap2/dss/hdmi4_core.c
	drivers/video/omap2/dss/hdmi4_core.h

caused by commits ef26958 (omapdss: HDMI: Rename hdmi driver files to nicer
names) and a few others that I didn't quite track down. But given that the
diff of the merge commit is empty I guess everything's well.

Thanks,
Thierry
