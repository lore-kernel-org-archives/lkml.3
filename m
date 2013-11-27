Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759452Ab3K0Bf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:35:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39265 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932392Ab3K0A6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:24 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Skeggs <bskeggs@redhat.com>, Ilia Mirkin <imirkin@alum.mit.edu>
Subject: [PATCH 3.12 016/116] drm/nvc0-/gr: fix a number of missing explicit array terminators...
Date: Tue, 26 Nov 2013 16:56:29 -0800
Message-Id: <20131127005738.068446774@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Skeggs <bskeggs@redhat.com>

commit 13d2b35a065399fb447c84e80368927e5f8bf086 upstream.

Signed-off-by: Ben Skeggs <bskeggs@redhat.com>
Cc: Ilia Mirkin <imirkin@alum.mit.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc1.c |    4 ++++
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c |    1 +
 drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd9.c |    1 +
 3 files changed, 6 insertions(+)

--- a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc1.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvc1.c
@@ -587,6 +587,7 @@ nvc1_grctx_init_unk58xx[] = {
 	{ 0x405870,   4, 0x04, 0x00000001 },
 	{ 0x405a00,   2, 0x04, 0x00000000 },
 	{ 0x405a18,   1, 0x04, 0x00000000 },
+	{}
 };
 
 static struct nvc0_graph_init
@@ -598,6 +599,7 @@ nvc1_grctx_init_rop[] = {
 	{ 0x408904,   1, 0x04, 0x62000001 },
 	{ 0x408908,   1, 0x04, 0x00c80929 },
 	{ 0x408980,   1, 0x04, 0x0000011d },
+	{}
 };
 
 static struct nvc0_graph_init
@@ -671,6 +673,7 @@ nvc1_grctx_init_gpc_0[] = {
 	{ 0x419000,   1, 0x04, 0x00000780 },
 	{ 0x419004,   2, 0x04, 0x00000000 },
 	{ 0x419014,   1, 0x04, 0x00000004 },
+	{}
 };
 
 static struct nvc0_graph_init
@@ -717,6 +720,7 @@ nvc1_grctx_init_tpc[] = {
 	{ 0x419e98,   1, 0x04, 0x00000000 },
 	{ 0x419ee0,   1, 0x04, 0x00011110 },
 	{ 0x419f30,  11, 0x04, 0x00000000 },
+	{}
 };
 
 void
--- a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd7.c
@@ -258,6 +258,7 @@ nvd7_grctx_init_hub[] = {
 	nvc0_grctx_init_unk78xx,
 	nvc0_grctx_init_unk80xx,
 	nvd9_grctx_init_rop,
+	NULL
 };
 
 struct nvc0_graph_init *
--- a/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd9.c
+++ b/drivers/gpu/drm/nouveau/core/engine/graph/ctxnvd9.c
@@ -466,6 +466,7 @@ nvd9_grctx_init_hub[] = {
 	nvc0_grctx_init_unk78xx,
 	nvc0_grctx_init_unk80xx,
 	nvd9_grctx_init_rop,
+	NULL
 };
 
 struct nvc0_graph_init *


