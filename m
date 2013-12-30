Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab3L3PDs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 10:03:48 -0500
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:57868 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755942Ab3L3PDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 10:03:46 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCH 0/7] vt6655: Cleanup of checkpatch errors
Date: Mon, 30 Dec 2013 15:52:30 +0100
Message-Id: <1388415157-17615-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up all checkpatch errors and some warnings
in some files of the vt6655 driver in staging.

The reference git tree is linux-next.

Some checkpatch warnings were not fixed, they are commented in the
particular patches.

Not all files of the driver were cleaned up in this patch series.

The patches should not incorporate functional changes.

-- 
1.8.1.2

