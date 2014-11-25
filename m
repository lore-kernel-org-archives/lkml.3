Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751996AbaKYQnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:43:00 -0500
Received: from mail-wg0-f47.google.com ([74.125.82.47]:35376 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751933AbaKYQm5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:42:57 -0500
Message-ID: <5474B18E.6030100@plexistor.com>
Date: Tue, 25 Nov 2014 18:42:54 +0200
From: Boaz Harrosh <boaz@plexistor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] .gitignore: Add Kdevelop4 project files
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boaz Harrosh <boaz@plexistor.com>

I'm not sure what is the costume with such IDE project files.
Most might be dot-files. It is kind of annoying for the Kdevelop4 user.

So please consider adding *.kdev4 files to be ignored?

Signed-off-by: Boaz Harrosh <boaz@plexistor.com>
---
 .gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/.gitignore b/.gitignore
index e213b27..02d6275 100644
--- a/.gitignore
+++ b/.gitignore
@@ -35,6 +35,7 @@
 modules.builtin
 Module.symvers
 *.dwo
+*.kdev4
 
 #
 # Top-level generic files
-- 
1.9.3

