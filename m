Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757904Ab3FUK6v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 06:58:51 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:10995 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab3FUK6t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 06:58:49 -0400
X-IronPort-AV: E=Sophos;i="4.87,912,1363132800"; 
   d="scan'208";a="5916353"
From: Roger Pau Monne <roger.pau@citrix.com>
To: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>
Subject: [PATCH 0/4] xen-block: bug fixes for indirect-descriptors
Date: Fri, 21 Jun 2013 12:56:52 +0200
Message-ID: <1371812216-17093-1-git-send-email-roger.pau@citrix.com>
X-Mailer: git-send-email 1.7.7.5 (Apple Git-26)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains a small number of bug fixes and improvements for 
xen-block indirect descriptors.
