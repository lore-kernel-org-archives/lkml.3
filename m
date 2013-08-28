Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754202Ab3H1PmI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 11:42:08 -0400
Received: from dupo.coraid.com ([208.71.232.133]:59142 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752936Ab3H1PmG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 11:42:06 -0400
Message-Id: <cover.1377185392.git.ecashin@coraid.com>
Subject: [PATCH 0/2] aoe: remove too-strict BUG from aoedev teardown and update udev example
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Wed, 28 Aug 2013 11:41:06 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series applies to linux-next/akpm fetched 22 August, commit
a187db44dd9b24a9eed2141af962306a36935423.  Yesterday's linux-next/akpm
has no updates to the aoe files that could conflict, though.

Ed L. Cashin (2):
  aoe: do not BUG if memory pressure prevented debugfs file creation
  aoe: remove do-nothing NAME="%k" term from example udev rules

 Documentation/aoe/udev.txt |    2 +-
 drivers/block/aoe/aoeblk.c |    1 -
 2 files changed, 1 insertions(+), 2 deletions(-)

