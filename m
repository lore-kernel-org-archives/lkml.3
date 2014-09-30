Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752082AbaI3EcK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 00:32:10 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34087 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751975AbaI3EcI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 00:32:08 -0400
From: Ankit Jindal <ankit.jindal@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: "Hans J. Koch" <hjk@hansjkoch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, patches@apm.com,
        linux-arm-kernel@lists.infradead.org, Rob Herring <robh+dt@kernel.org>,
        Tushar Jagad <tushar.jagad@linaro.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, Ankit Jindal <ankit.jindal@linaro.org>
Subject: [PATCH v2 3/6] Documentation: Update documentation for UIO_MEM_PHYS_CACHE
Date: Tue, 30 Sep 2014 09:56:06 +0530
Message-Id: <1412051169-9142-4-git-send-email-ankit.jindal@linaro.org>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412051169-9142-1-git-send-email-ankit.jindal@linaro.org>
References: <1412051169-9142-1-git-send-email-ankit.jindal@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch updates UIO documentation for new mem region
type UIO_MEM_PHYS_CACHE.

Signed-off-by: Ankit Jindal <ankit.jindal@linaro.org>
Signed-off-by: Tushar Jagad <tushar.jagad@linaro.org>
---
 Documentation/DocBook/uio-howto.tmpl |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/DocBook/uio-howto.tmpl b/Documentation/DocBook/uio-howto.tmpl
index bbe9c1f..baa9185 100644
--- a/Documentation/DocBook/uio-howto.tmpl
+++ b/Documentation/DocBook/uio-howto.tmpl
@@ -529,8 +529,9 @@ the memory region, it will show up in the corresponding sysfs node.
 <varname>int memtype</varname>: Required if the mapping is used. Set this to
 <varname>UIO_MEM_PHYS</varname> if you you have physical memory on your
 card to be mapped. Use <varname>UIO_MEM_LOGICAL</varname> for logical
-memory (e.g. allocated with <function>kmalloc()</function>). There's also
-<varname>UIO_MEM_VIRTUAL</varname> for virtual memory.
+memory (e.g. allocated with <function>kmalloc()</function>). There are also
+<varname>UIO_MEM_VIRTUAL</varname> for virtual memory, and
+<varname>UIO_MEM_PHYS_CACHE</varname> for cacheable access to physical memory.
 </para></listitem>
 
 <listitem><para>
-- 
1.7.9.5

