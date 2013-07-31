Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760152Ab3GaPC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jul 2013 11:02:58 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:62882 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab3GaPC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jul 2013 11:02:57 -0400
X-IronPort-AV: E=Sophos;i="4.89,787,1367971200"; 
   d="scan'208";a="7325896"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/3] xen: fixes for gnt and block
Date: Wed, 31 Jul 2013 17:00:41 +0200
Message-ID: <1375282844-4314-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contain a small bugfix for the grant table code (patch 1) 
and a couple of improvements to blkfront (patches 2 and 3) to make it 
work better if there's a shortage on available free grants.
