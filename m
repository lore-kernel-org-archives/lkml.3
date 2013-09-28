Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820Ab3I1AWs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 20:22:48 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:42948 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753522Ab3I1AWo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 20:22:44 -0400
Date: Fri, 27 Sep 2013 19:22:38 -0500
From: "Philip J. Kelleher" <pjk1939@linux.vnet.ibm.com>
To: axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, brking@linux.vnet.ibm.com
Subject: [PATCH 0/1] rsxx: driver bug fix
Message-ID: <20130928002238.GA13456@oc6784271780.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13092800-3532-0000-0000-000001C1641B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The incoming patch is for the rsxx driver (drivers/block/rsxx)

This patch fixes a kernel panic injected by patch id
8d26750143341831bc312f61c5ed141eeb75b8d0 where discards
are getting mapped through the pci_map_page function call.

This patch relies on git commit 8d26750143341831bc312f61c5ed141eeb75b8d0.

Regards,
- Philip Kelleher
	

