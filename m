Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758846Ab3BVU7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 15:59:47 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:58841 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752944Ab3BVU7p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 15:59:45 -0500
Message-ID: <1361566784.2030.6.camel@joe-AO722>
Subject: [PATCH] checkpatch: Improve CamelCase test for Page
From: Joe Perches <joe@perches.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Date: Fri, 22 Feb 2013 12:59:44 -0800
In-Reply-To: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
References: <20130222204253.A37B931C1C1@corp2gmr1-1.hot.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the ClearPage/SetPage/TestClearPage/TestSetPage
variants to the not reported Page CamelCase variables.

Signed-off-by: Joe Perches <joe@perches.com>
---
 scripts/checkpatch.pl | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index 747bcd7..8a32306 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2930,7 +2930,7 @@ sub process {
 			my $var = $1;
 			if ($var !~ /$Constant/ &&
 			    $var =~ /[A-Z]\w*[a-z]|[a-z]\w*[A-Z]/ &&
-			    $var !~ /^Page[A-Z]/ &&
+			    $var !~ /"^(?:Clear|Set|TestClear|TestSet|)Page[A-Z]/ &&
 			    !defined $camelcase{$var}) {
 				$camelcase{$var} = 1;
 				WARN("CAMELCASE",


