Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215AbaCGNB5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 08:01:57 -0500
Received: from 82-68-191-81.dsl.posilan.com ([82.68.191.81]:59408 "EHLO
	rainbowdash.ducie.codethink.co.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752748AbaCGNBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:01:48 -0500
From: Ben Dooks <ben.dooks@codethink.co.uk>
To: linux-media@vger.kernel.org
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-kernel@vger.kernel.org, magnus.damm@opensource.se,
        linux-sh@vger.kernel.org, linux-kernel@lists.codethink.co.uk
Subject: soc_camera rcar_vin support for device-tree binding
Date: Fri,  7 Mar 2014 13:01:34 +0000
Message-Id: <1394197299-17528-1-git-send-email-ben.dooks@codethink.co.uk>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a series of patches to get towards the point the renesas
rcar_vin driver can be bound via device-tree. Patches 1 and 2 add
the device tree nodes, patch 3 is one which has been in my tree
for a while and the last two modify the rcar_vin driver.

