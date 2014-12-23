Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756387AbaLWQcX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:32:23 -0500
Received: from tex.lwn.net ([70.33.254.29]:51369 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756113AbaLWQcT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:32:19 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH v2] Docs: Modernize SubmittingPatches
Date: Tue, 23 Dec 2014 09:32:00 -0700
Message-Id: <1419352327-4517-1-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 2.1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The SubmittingPatches file still shows a lot of its roots from the era when
we all sent stuff straight to Linus and hoped for the best.  I've gone in
and thrashed it up to reflect an age where few of us type our own "diff"
commands anymore.  Also added a section on preparing signed tags for pull
requests.

v2 incorporates comments from Randy Dunlap, Frank Rowand, and Mark Brown;
it also splits the series into more comprehensible chunks.  My apologies
for sending out the jumble that was the first version.

 SubmittingPatches |  438 ++++++++++++++++++++++++++----------------------------
 1 file changed, 217 insertions(+), 221 deletions(-)


