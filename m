Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756582AbaICPJX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 11:09:23 -0400
Received: from mail-qg0-f41.google.com ([209.85.192.41]:55350 "EHLO
	mail-qg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753701AbaICPJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 11:09:21 -0400
Message-ID: <54072F1D.4060405@gmail.com>
Date: Wed, 03 Sep 2014 11:09:17 -0400
From: Pranith Kumar <bobby.prani@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Bogus error in checkpatch.pl
References: <CAJhHMCDMuByuTdOwTscZ0tF3WopYrqfYnRD=5sPHXGQZZu09wg@mail.gmail.com>	 <1409718353.2715.3.camel@joe-AO725>	 <CAJhHMCBuUvSb46Q+kvryv2vu=1Pjq8odSs6u7P1h3HyG21k2AA@mail.gmail.com> <1409722470.2715.5.camel@joe-AO725>
In-Reply-To: <1409722470.2715.5.camel@joe-AO725>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 09/03/2014 01:34 AM, Joe Perches wrote:
> Maybe.  Suggest a modified message.
>

How about the following?

diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index b602ed2..bcc384e 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -2143,7 +2143,7 @@ sub process {
                        my $desc = 'commit description';
                        ($id, $desc) = git_commit_info($orig_commit, $id, $desc);
                        ERROR("GIT_COMMIT_ID",
-                             "Please use 12 or more chars for the git commit ID like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
+                             "Please use 12 or more chars for the git commit ID and parentheses for the commit message like: '${init_char}ommit $id (\"$desc\")'\n" . $herecurr);
                }
 
 # Check for added, moved or deleted files

