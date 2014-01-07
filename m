Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751309AbaAGMMq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 07:12:46 -0500
Received: from mx-rz-3.rrze.uni-erlangen.de ([131.188.11.22]:48071 "EHLO
	mx-rz-3.rrze.uni-erlangen.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750908AbaAGMMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 07:12:37 -0500
X-RRZE-Submit-IP: 131.188.42.195
From: Michael Gunselmann <michael.gunselmann@studium.uni-erlangen.de>
To: michael.gunselmann@studium.uni-erlangen.de
Cc: martin.hofmann@studium.uni-erlangen.de, forest@alittletooquiet.net,
        gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, linux-kernel@i4.cs.fau.de
Subject: [PATCHv2 0/7] vt6655: Cleanup of checkpatch errors
Date: Tue,  7 Jan 2014 13:11:44 +0100
Message-Id: <1389096711-8595-1-git-send-email-michael.gunselmann@studium.uni-erlangen.de>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series cleans up some checkpatch errors and warnings
in some files of the vt6655 driver in staging.

The reference git tree is linux-next.

Not all files of the driver were cleaned up in this patch series.

The patches should not incorporate functional changes.

-- 
1.8.1.2

