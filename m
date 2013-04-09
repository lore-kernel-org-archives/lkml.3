Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933173Ab3DIE15 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 00:27:57 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53452 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750713Ab3DIE14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 00:27:56 -0400
Message-ID: <1365481674.6865.16.camel@joe-AO722>
Subject: checkpatch: Warn on space before semicolon
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Chanho Min <chanho.min@lge.com>,
        Nadia Yvette Chambers <nyc@holomorphy.com>,
        Jiri Kosina <jkosina@suse.cz>, Guennadi Liakhovetski <lg@denx.de>,
        linux-kernel@vger.kernel.org
Date: Mon, 08 Apr 2013 21:27:54 -0700
In-Reply-To: <20130408211859.b5549325.akpm@linux-foundation.org>
References: <1365475486-14371-1-git-send-email-chanho.min@lge.com>
	 <20130408201001.f4c74887.akpm@linux-foundation.org>
	 <1365477500.2012.5.camel@joe-AO722>
	 <20130408211859.b5549325.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make space before semicolon a warning instead
of a --strict CHK test.

Signed-off-by: Joe Perches <joe@perches.com>
---
>> There's no specific CodingStyle violation here
> Let's fix CodingStyle then?

I'll leave that bit for you...
 
 scripts/checkpatch.pl | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b28cc38..90eb022 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2514,8 +2514,8 @@ sub process {
 
 # check for whitespace before a non-naked semicolon
 		if ($line =~ /^\+.*\S\s+;/) {
-			CHK("SPACING",
-			    "space prohibited before semicolon\n" . $herecurr);
+			WARN("SPACING",
+			     "space prohibited before semicolon\n" . $herecurr);
 		}
 
 # Check operator spacing.


