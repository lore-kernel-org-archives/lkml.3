Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760734AbaJ1Har (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 03:30:47 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44998 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932276AbaJ1Dl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Oct 2014 23:41:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Allen Pais <allen.pais@oracle.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 133/146] sparc64: cpu hardware caps support for sparc M6 and M7
Date: Tue, 28 Oct 2014 11:34:35 +0800
Message-Id: <20141028033349.210189971@linuxfoundation.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <20141028033343.441992423@linuxfoundation.org>
References: <20141028033343.441992423@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Allen Pais <allen.pais@oracle.com>

Signed-off-by: Allen Pais <allen.pais@oracle.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/setup_64.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/sparc/kernel/setup_64.c
+++ b/arch/sparc/kernel/setup_64.c
@@ -500,12 +500,16 @@ static void __init init_sparc64_elf_hwca
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA3 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA4 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA5 ||
+		    sun4v_chip_type == SUN4V_CHIP_SPARC_M6 ||
+		    sun4v_chip_type == SUN4V_CHIP_SPARC_M7 ||
 		    sun4v_chip_type == SUN4V_CHIP_SPARC64X)
 			cap |= HWCAP_SPARC_BLKINIT;
 		if (sun4v_chip_type == SUN4V_CHIP_NIAGARA2 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA3 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA4 ||
 		    sun4v_chip_type == SUN4V_CHIP_NIAGARA5 ||
+		    sun4v_chip_type == SUN4V_CHIP_SPARC_M6 ||
+		    sun4v_chip_type == SUN4V_CHIP_SPARC_M7 ||
 		    sun4v_chip_type == SUN4V_CHIP_SPARC64X)
 			cap |= HWCAP_SPARC_N2;
 	}
@@ -533,6 +537,8 @@ static void __init init_sparc64_elf_hwca
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA3 ||
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA4 ||
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA5 ||
+			    sun4v_chip_type == SUN4V_CHIP_SPARC_M6 ||
+			    sun4v_chip_type == SUN4V_CHIP_SPARC_M7 ||
 			    sun4v_chip_type == SUN4V_CHIP_SPARC64X)
 				cap |= (AV_SPARC_VIS | AV_SPARC_VIS2 |
 					AV_SPARC_ASI_BLK_INIT |
@@ -540,6 +546,8 @@ static void __init init_sparc64_elf_hwca
 			if (sun4v_chip_type == SUN4V_CHIP_NIAGARA3 ||
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA4 ||
 			    sun4v_chip_type == SUN4V_CHIP_NIAGARA5 ||
+			    sun4v_chip_type == SUN4V_CHIP_SPARC_M6 ||
+			    sun4v_chip_type == SUN4V_CHIP_SPARC_M7 ||
 			    sun4v_chip_type == SUN4V_CHIP_SPARC64X)
 				cap |= (AV_SPARC_VIS3 | AV_SPARC_HPC |
 					AV_SPARC_FMAF);


