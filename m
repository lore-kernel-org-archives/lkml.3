Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932273AbaE1PNX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 11:13:23 -0400
Received: from isis.lip6.fr ([132.227.60.2]:50513 "EHLO isis.lip6.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605AbaE1PNV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 11:13:21 -0400
X-pt: isis.lip6.fr
From: Benoit Taine <benoit.taine@lip6.fr>
To: kernel-janitors@vger.kernel.org
Cc: benoit.taine@lip6.fr, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        alsa-devel@alsa-project.org
Subject: [PATCH 0/2] Use resource_size instead of computation
Date: Wed, 28 May 2014 17:14:05 +0200
Message-Id: <1401290047-30005-1-git-send-email-benoit.taine@lip6.fr>
X-Mailer: git-send-email 1.9.3
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.4.3 (isis.lip6.fr [132.227.60.2]); Wed, 28 May 2014 17:13:12 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These patches enhance kernel style usage, and make use of the
resource_size() function instead of explicit computation.

The semantic patch at scripts/coccinelle/api/resource_size.cocci was
used to detect and edit this situation.
