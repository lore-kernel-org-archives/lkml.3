Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756023Ab3HLK4C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Aug 2013 06:56:02 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:30697 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755524Ab3HLKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Aug 2013 06:55:59 -0400
X-IronPort-AV: E=Sophos;i="4.89,861,1367971200"; 
   d="scan'208";a="7708587"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 0/2] xen-blkfront: fixes for blkfront
Date: Mon, 12 Aug 2013 12:53:42 +0200
Message-ID: <1376304824-1967-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains a couple of improvements to blkfront to make it 
work better if there's a shortage on available free grants.
