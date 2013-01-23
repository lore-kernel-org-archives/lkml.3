Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755927Ab3AWPbE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 10:31:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab3AWPbD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 10:31:03 -0500
From: Michal Marek <mmarek@suse.cz>
To: dhowells@redhat.com, rusty@ozlabs.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 0/4] MODSIGN: Allow to sign modules outside build
Date: Wed, 23 Jan 2013 16:30:40 +0100
Message-Id: <1358955044-27407-1-git-send-email-mmarek@suse.cz>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This series allows to sign modules outside of the build tree and / or
without direct access to the private key.

Thanks,
Michal

Michal Marek (4):
  MODSIGN: Simplify Makefile with a Kconfig helper
  MODSIGN: Specify the hash algorithm on sign-file command line
  MODSIGN: Add -s <signature> option to sign-file
  MODSIGN: Add option to not sign modules during modules_install

 Makefile          |    4 +-
 init/Kconfig      |   20 ++++++++
 kernel/Makefile   |   24 +---------
 scripts/sign-file |  135 +++++++++++++++++++++++++----------------------------
 4 files changed, 88 insertions(+), 95 deletions(-)

-- 
1.7.10.4

