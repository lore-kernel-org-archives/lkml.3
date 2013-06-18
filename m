Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932718Ab3FRPlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 11:41:16 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:50693 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756262Ab3FRPlP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 11:41:15 -0400
Date: Tue, 18 Jun 2013 18:41:04 +0300 (EEST)
From: Pekka Enberg <penberg@kernel.org>
X-X-Sender: penberg@tux.localdomain
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        Christoph Lameter <cl@linux.com>, linux-kernel@vger.kernel.org
Subject: [GIT PULL] SLAB fixes for v3.10-rc6
Message-ID: <alpine.LFD.2.03.1306181840500.2716@kernel.org>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull the latest SLAB tree from:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent

It contains a slab regression fix by Sasha Levin.

			Pekka

------------------>
The following changes since commit 26e04462c8b78d079d3231396ec72d58a14f114b:

  Merge git://git.kernel.org/pub/scm/linux/kernel/git/davem/net (2013-06-12 17:18:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/penberg/linux.git slab/urgent

Sasha Levin (1):
      slab: prevent warnings when allocating with __GFP_NOWARN

 mm/slab_common.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)
