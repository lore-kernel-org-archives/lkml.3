Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbaKUBfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 20:35:32 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44296 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756487AbaKUBfa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 20:35:30 -0500
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pantelis Antoniou <pantelis.antoniou@konsulko.com>
Cc: Rob Herring <robh+dt@kernel.org>
Subject: [PATCH 0/8] of: DT Overlay patches to be merged
Date: Fri, 21 Nov 2014 01:35:07 +0000
Message-Id: <1416533715-9758-1-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've finally queued up the following core patches for devicetree overlay
support.  The patches have changed a bit since the v8 series that
Pantelis published. Mostly fixups to issues raised on the list.

Please review and let me know if you have any concerns.

There are still several overlay patches that need to be merged to add
support to the i2c and spi busses as well as the configfs interface.
I'll be looking at those patches next.

g.

