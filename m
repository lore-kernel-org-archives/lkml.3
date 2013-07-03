Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab3GCCBF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 22:01:05 -0400
Received: from dupo.coraid.com ([208.71.232.133]:55021 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753797Ab3GCCBE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 22:01:04 -0400
Message-Id: <cover.1372814257.git.ecashin@coraid.com>
Subject: [PATCH 0/3] aoe: performance enhancements through v83
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Tue, 2 Jul 2013 21:44:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series applies to today's linux-next/akpm, commit
cbbc4a736dfca9a1ade0b13219d98d12601c1c06.

This second submission includes a comment in the first patch
suggested by Andrew Morton.


Ed L. Cashin (3):
  aoe: perform I/O completions in parallel
  aoe: update copyright date
  aoe: update internal version number to v83

 drivers/block/aoe/aoe.h    |   11 ++-
 drivers/block/aoe/aoecmd.c |  154 ++++++++++++++++++++++++++++++++++++--------
 drivers/block/aoe/aoedev.c |    3 +-
 drivers/block/aoe/aoenet.c |    7 +-
 4 files changed, 139 insertions(+), 36 deletions(-)

