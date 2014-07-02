Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757973AbaGBTy1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 15:54:27 -0400
Received: from smtp.citrix.com ([66.165.176.89]:64471 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756124AbaGBTyX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 15:54:23 -0400
X-IronPort-AV: E=Sophos;i="5.01,590,1400025600"; 
   d="scan'208";a="149390665"
From: Zoltan Kiss <zoltan.kiss@citrix.com>
To: Steffen Klassert <steffen.klassert@secunet.com>,
        Mathias Krause <minipli@googlemail.com>,
        Daniel Borkmann <dborkman@redhat.com>
CC: Zoltan Kiss <zoltan.kiss@citrix.com>,
        "David S. Miller" <davem@davemloft.net>, Thomas Graf <tgraf@suug.ch>,
        Joe Perches <joe@perches.com>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>
Subject: [PATCH net-next v2 0/3] pktgen: Upstreaming features useful for xen-netback/front testing
Date: Wed, 2 Jul 2014 20:54:12 +0100
Message-ID: <1404330855-24546-1-git-send-email-zoltan.kiss@citrix.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.80.2.133]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series is my work during stressing the xen network drivers, hopefully
others can benefit from it.
1/3: Filling payload with pattern, useful for checking data correctness when the
packets travelling without checksum (~ intrahost VM-to-VM). Already sent it
separately feq times, so its version number differs
2/3: fine-grained buffer geometrics
3/3: sending TCP GSO packets. This is an RFC yet, as I'm not certain about all
things changed here

Signed-off-by: Zoltan Kiss <zoltan.kiss@citrix.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Thomas Graf <tgraf@suug.ch>
Cc: Joe Perches <joe@perches.com>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xenproject.org

v2: respin for net-next changes
