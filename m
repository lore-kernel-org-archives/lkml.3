Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759785Ab3EORU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 13:20:27 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:42801 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759672Ab3EORUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 13:20:25 -0400
Date: Wed, 15 May 2013 20:20:21 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Rob Landley <rob@landley.net>
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Eduardo Valentin <eduardo.valentin@ti.com>
Subject: [patch] Documentation: allow multiple return statements per function
Message-ID: <20130515172021.GA304@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A surprising number of newbies interpret this section to mean that only
one return statement is allowed per function.  Part of the problem is
that the "one return statement per function" rule is an actual style
guideline that people are used to from other projects.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/Documentation/CodingStyle b/Documentation/CodingStyle
index e00b8f0..7fe0546 100644
--- a/Documentation/CodingStyle
+++ b/Documentation/CodingStyle
@@ -389,7 +389,8 @@ Albeit deprecated by some people, the equivalent of the goto statement is
 used frequently by compilers in form of the unconditional jump instruction.
 
 The goto statement comes in handy when a function exits from multiple
-locations and some common work such as cleanup has to be done.
+locations and some common work such as cleanup has to be done.  If there is no
+cleanup needed then just return directly.
 
 The rationale is:
 
