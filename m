Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab3DQTJw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:09:52 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:47414 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755943Ab3DQTJv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:09:51 -0400
From: Dan Murphy <dmurphy@ti.com>
To: <b-cousson@ti.com>, <tony@atomide.com>, <linux@arm.linux.org.uk>
CC: <linux-omap@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH] Fix omap4 panda LED definitions
Date: Wed, 17 Apr 2013 14:09:37 -0500
Message-ID: <1366225778-6083-1-git-send-email-dmurphy@ti.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The LED GPIOs between the 4430 (a1-a4) and 4460 (es) panda boards
are different.  This patch abstracts the LED definitions into the 
respective board files.

