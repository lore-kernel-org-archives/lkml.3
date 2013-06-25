Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753953Ab3FYTMR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 15:12:17 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40859 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752032Ab3FYSdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 17/95] parisc: add rp5470 entry to machine database
Date: Tue, 25 Jun 2013 11:32:04 -0700
Message-Id: <20130625182155.606133597@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 949451b9b19da5e998778eb78929aafc73b5c227 upstream.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/kernel/hardware.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/parisc/kernel/hardware.c
+++ b/arch/parisc/kernel/hardware.c
@@ -222,6 +222,7 @@ static struct hp_hardware hp_hardware_li
 	{HPHW_NPROC,0x5DD,0x4,0x81,"Duet W2"},
 	{HPHW_NPROC,0x5DE,0x4,0x81,"Piccolo W+"},
 	{HPHW_NPROC,0x5DF,0x4,0x81,"Cantata W2"},
+	{HPHW_NPROC,0x5DF,0x0,0x00,"Marcato W+? (rp5470)"},
 	{HPHW_NPROC,0x5E0,0x4,0x91,"Cantata DC- W2"},
 	{HPHW_NPROC,0x5E1,0x4,0x91,"Crescendo DC- W2"},
 	{HPHW_NPROC,0x5E2,0x4,0x91,"Crescendo 650 W2"},


