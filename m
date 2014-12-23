Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbaLWQco (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 11:32:44 -0500
Received: from tex.lwn.net ([70.33.254.29]:51391 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756295AbaLWQcW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 11:32:22 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: linux-kernel@vger.kernel.org
Cc: Randy Dunlap <rdunlap@infradead.org>, Jonathan Corbet <corbet@lwn.net>
Subject: [PATCH 7/7] Docs: SubmittingPatches: mention using pull requests as a cover letter
Date: Tue, 23 Dec 2014 09:32:07 -0700
Message-Id: <1419352327-4517-8-git-send-email-corbet@lwn.net>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1419352327-4517-1-git-send-email-corbet@lwn.net>
References: <1419352327-4517-1-git-send-email-corbet@lwn.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Suggested-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Jonathan Corbet <corbet@lwn.net>
---
 Documentation/SubmittingPatches | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
index 1f4e8c8710a7..40b619ef9b6a 100644
--- a/Documentation/SubmittingPatches
+++ b/Documentation/SubmittingPatches
@@ -725,7 +725,9 @@ maintainer pull them directly into the subsystem repository with a
 "git pull" operation.  Note, however, that pulling patches from a developer
 requires a higher degree of trust than taking patches from a mailing list.
 As a result, many subsystem maintainers are reluctant to take pull
-requests, especially from new, unknown developers.
+requests, especially from new, unknown developers.  If in doubt you can use
+the pull request as the cover letter for a normal posting of the patch
+series, giving the maintainer the option of using either.
 
 A pull request should have [GIT] or [PULL] in the subject line.  The
 request itself should include the repository name and the branch of
-- 
2.1.0

