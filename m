Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755191AbbAFL10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2015 06:27:26 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:53536 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbbAFL1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2015 06:27:12 -0500
From: esben.haabendal@gmail.com
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Cc: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Esben Haabendal <eha@deif.com>
Subject: [PATCH 3/3] powerpc: Add .gitignore entry for built DTB files
Date: Tue,  6 Jan 2015 12:27:00 +0100
Message-Id: <1420543620-20658-3-git-send-email-esben.haabendal@gmail.com>
X-Mailer: git-send-email 2.1.4
In-Reply-To: <1420543620-20658-1-git-send-email-esben.haabendal@gmail.com>
References: <1420543620-20658-1-git-send-email-esben.haabendal@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Esben Haabendal <eha@deif.com>

Signed-off-by: Esben Haabendal <eha@deif.com>
---
 arch/powerpc/boot/.gitignore | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/boot/.gitignore b/arch/powerpc/boot/.gitignore
index d61c035..38e6492 100644
--- a/arch/powerpc/boot/.gitignore
+++ b/arch/powerpc/boot/.gitignore
@@ -29,6 +29,7 @@ zImage.*lds
 zImage.miboot
 zImage.pmac
 zImage.pseries
+*.dtb
 zconf.h
 zlib.h
 zutil.h
-- 
2.1.4

