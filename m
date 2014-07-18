Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422786AbaGRSIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 14:08:15 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:30858 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161028AbaGRSIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 14:08:13 -0400
X-IronPort-AV: E=Sophos;i="5.01,686,1400025600"; 
   d="scan'208";a="154179911"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Wei Liu <wei.liu2@citrix.com>, Ian Campbell <Ian.Campbell@citrix.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH net 0/4 v2] xen-netback: Fixing up xenvif_tx_check_gop
Date: Fri, 18 Jul 2014 19:08:01 +0100
Message-ID: <1405706885-16763-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series fixes a lot of bugs on the error path around this function, which
were introduced with my grant mapping series in 3.15. They apply to the latest
net tree, but probably to net-next as well without any modification.
I'll post an another series which applies to 3.15 stable, as the problem was
first discovered there. The only difference is that the "queue" variable name is
replaced to "vif".

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Reported-by: Armin Zentai <armin.zentai@ezit.hu>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org

