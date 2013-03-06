Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756747Ab3CFNv0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Mar 2013 08:51:26 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:12285 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753484Ab3CFNvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Mar 2013 08:51:24 -0500
X-Authority-Analysis: v=2.0 cv=H5hZMpki c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=Ciwy3NGCPMMA:10 a=T9fl5OTWkEUA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=kk4o2OyOWIIA:10 a=o2fZvP7bP7vlnmshWXkA:9 a=rpWZQO1zt1AA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-Id: <20130306134916.923746858@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Mar 2013 08:49:16 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Hiraku Toyooka <hiraku.toyooka.gu@hitachi.com>
Subject: [RFC][PATCH 0/2] tracing: Better snapshot handling and documentation
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hiraku,

Here's the patches that I updated to the snapshot feature.
Can you add your Acked-by. I want this to get into 3.9 as the current
method shouldn't become an ABI yet.

Thanks!

-- Steve


Steven Rostedt (Red Hat) (2):
      tracing: Add help of snapshot feature when snapshot is empty
      tracing: Do not return EINVAL in snapshot when not allocated

----
 kernel/trace/trace.c |   27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

