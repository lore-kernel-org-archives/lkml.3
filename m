Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932523Ab3GBVcw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 17:32:52 -0400
Received: from noserose.net ([66.220.18.76]:46017 "HELO noserose.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S932486Ab3GBVcu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 17:32:50 -0400
Date: Tue, 2 Jul 2013 14:21:41 -0700
Message-Id: <cover.1372710099.git.ecashin@coraid.com>
From: ecashin@noserose.net
Subject: [PATCH 0/3] aoe: performance enhancements through v83
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series applies to today's linux-next/akpm, commit
cbbc4a736dfca9a1ade0b13219d98d12601c1c06.


Ed L. Cashin (3):
  aoe: perform I/O completions in parallel
  aoe: update copyright date
  aoe: update internal version number to v83

 drivers/block/aoe/aoe.h    |   11 ++-
 drivers/block/aoe/aoecmd.c |  155 ++++++++++++++++++++++++++++++++++++--------
 drivers/block/aoe/aoedev.c |    3 +-
 drivers/block/aoe/aoenet.c |    7 +-
 4 files changed, 140 insertions(+), 36 deletions(-)

