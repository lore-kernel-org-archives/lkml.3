Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933708Ab3HGWHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 18:07:05 -0400
Received: from ares07.inai.de ([5.9.24.206]:59998 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933454Ab3HGWHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 18:07:03 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Aug 2013 18:07:03 EDT
From: Jan Engelhardt <jengelh@inai.de>
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Cc: linux-kernel@vger.kernel.org
Subject: Potentially missing "else"
Date: Wed,  7 Aug 2013 23:58:57 +0200
Message-Id: <1375912738-25114-1-git-send-email-jengelh@inai.de>
X-Mailer: git-send-email 1.8.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The following changes since commit 48a409644199d5efff6d966cd72ccc7f5a06c2a5:

  shell-completion: Make options accept '=' as last char (2013-08-02 12:07:39 -0300)

are available in the git repository at:

  git://git.inai.de/kmod master

for you to fetch changes up to e4523541e7f26457cf7078d5f30e091d1b24e3a9:

  depmod: add missing "else" clause (2013-08-07 23:50:51 +0200)

----------------------------------------------------------------
Jan Engelhardt (1):
      depmod: add missing "else" clause

 libkmod/libkmod-config.c | 2 +-
 tools/depmod.c           | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)
