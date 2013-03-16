Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752508Ab3CPVLb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 17:11:31 -0400
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:53978
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751433Ab3CPVL1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 17:11:27 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        andi@firstfloor.org, akpm@linux-foundation.org, linux-mm@kvack.org,
        kamezawa.hiroyuki@gmail.com, mhocko@suse.cz, hannes@cmpxchg.org,
        yinghan@google.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: hv: balloon 
Date: Sat, 16 Mar 2013 14:41:28 -0700
Message-Id: <1363470088-24565-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support 2M page allocations when memory is ballooned out of the
guest. Hyper-V Dynamic Memory protocol is optimized around the ability
to move memory in 2M chunks.

K. Y. Srinivasan (2):
  mm: Export split_page()
  Drivers: hv: balloon: Support 2M page allocations for ballooning

 drivers/hv/hv_balloon.c |   18 ++++++++++++++++--
 mm/page_alloc.c         |    1 +
 2 files changed, 17 insertions(+), 2 deletions(-)

-- 
1.7.4.1

