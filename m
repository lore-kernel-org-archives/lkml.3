Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753157Ab3HBBaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 21:30:08 -0400
Received: from dupo.coraid.com ([208.71.232.133]:57169 "EHLO coraid.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751448Ab3HBBaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 21:30:07 -0400
Message-Id: <cover.1375320764.git.ecashin@coraid.com>
Subject: [PATCH] aoe: respect compound page reference tracking expectations
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, ecashin@coraid.com
From: Ed Cashin <ecashin@coraid.com>
X-Mailer: nedmail
Date: Thu, 1 Aug 2013 21:29:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series applies to today's linux-next/akpm, commit
651e600ff3ecc4ac06747313a1c49d89a9ce988e.

Ed L. Cashin (1):
  aoe: adjust ref of head for compound page tails

 drivers/block/aoe/aoecmd.c |   17 +++++++----------
 1 files changed, 7 insertions(+), 10 deletions(-)

