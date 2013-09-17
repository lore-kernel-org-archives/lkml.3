Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab3IQLO5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 07:14:57 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35671 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752471Ab3IQLO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 07:14:56 -0400
Subject: [PATCH 1/2] MPILIB: add module description and license
To: David Howells <dhowells@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>,
        linux-kernel@vger.kernel.org
From: Konstantin Khlebnikov <khlebnikov@openvz.org>
Date: Tue, 17 Sep 2013 15:14:52 +0400
Message-ID: <20130917111452.12333.1997.stgit@zurg>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes lack of license, otherwise mpi.ko taints kernel.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
---
 lib/mpi/mpiutil.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/lib/mpi/mpiutil.c b/lib/mpi/mpiutil.c
index 657979f..bf076d2 100644
--- a/lib/mpi/mpiutil.c
+++ b/lib/mpi/mpiutil.c
@@ -121,3 +121,6 @@ void mpi_free(MPI a)
 	kfree(a);
 }
 EXPORT_SYMBOL_GPL(mpi_free);
+
+MODULE_DESCRIPTION("Multiprecision maths library");
+MODULE_LICENSE("GPL");

