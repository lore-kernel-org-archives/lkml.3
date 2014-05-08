Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754676AbaEHRDZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 13:03:25 -0400
Received: from mailrelay007.isp.belgacom.be ([195.238.6.173]:45762 "EHLO
	mailrelay007.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752606AbaEHRDY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 13:03:24 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ap4KAFK4a1NR87v8/2dsb2JhbABZgwaCQaoiBAQBAQUBmhWBExd0gmYcIxiBAiQTiEUB0FaFVoh8hEYBA48bihwBknuDODs
Date: Thu, 8 May 2014 19:03:20 +0200
From: Fabian Frederick <fabf@skynet.be>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: akpm <akpm@linux-foundation.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 1/1] kernel/tracepoint.c: kernel-doc fixes
Message-Id: <20140508190320.609a8ed7d7950b5a0734628d@skynet.be>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 kernel/tracepoint.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/tracepoint.c b/kernel/tracepoint.c
index ac5b23c..1b0a61c 100644
--- a/kernel/tracepoint.c
+++ b/kernel/tracepoint.c
@@ -239,6 +239,7 @@ static int tracepoint_remove_func(struct tracepoint *tp,
  * tracepoint_probe_register -  Connect a probe to a tracepoint
  * @tp: tracepoint
  * @probe: probe handler
+ * @data: tracepoint data
  *
  * Returns 0 if ok, error value on error.
  * Note: if @tp is within a module, the caller is responsible for
@@ -264,6 +265,7 @@ EXPORT_SYMBOL_GPL(tracepoint_probe_register);
  * tracepoint_probe_unregister -  Disconnect a probe from a tracepoint
  * @tp: tracepoint
  * @probe: probe function pointer
+ * @data: tracepoint data
  *
  * Returns 0 if ok, error value on error.
  */
-- 
1.9.1

