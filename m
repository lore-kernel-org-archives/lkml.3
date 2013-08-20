Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751226Ab3HTJaQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 05:30:16 -0400
Received: from service87.mimecast.com ([91.220.42.44]:34263 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750923Ab3HTJaL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 05:30:11 -0400
From: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Cc: Sudeep.KarkadaNagesha@arm.com, Viresh Kumar <viresh.kumar@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Jonas Bonn <jonas@southpole.se>, Michal Simek <monstr@monstr.eu>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
Subject: [PATCH v4 01/19] microblaze: remove undefined of_get_cpu_node declaration
Date: Tue, 20 Aug 2013 10:30:03 +0100
Message-Id: <1376991021-12160-2-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
References: <1374492747-13879-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
 <1376991021-12160-1-git-send-email-Sudeep.KarkadaNagesha@arm.com>
X-OriginalArrivalTime: 20 Aug 2013 09:30:07.0693 (UTC) FILETIME=[DBF7F7D0:01CE9D87]
X-MC-Unique: 113082010300907001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r7K9Y1BX012323

From: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>

This patch removes the declaration of the function 'of_get_cpu_node'
which is not defined for microblaze. This is in preparation to move
it's definition from PPC to DT common code.

Michal Simek says: "it was just there because Microblaze
was based on powerpc code"

Acked-by: Michal Simek <monstr@monstr.eu>
Signed-off-by: Sudeep KarkadaNagesha <sudeep.karkadanagesha@arm.com>
---
 arch/microblaze/include/asm/prom.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/arch/microblaze/include/asm/prom.h b/arch/microblaze/include/asm/prom.h
index 20c5e8e..9977816 100644
--- a/arch/microblaze/include/asm/prom.h
+++ b/arch/microblaze/include/asm/prom.h
@@ -50,9 +50,6 @@ void of_parse_dma_window(struct device_node *dn, const void *dma_window_prop,
 
 extern void kdump_move_device_tree(void);
 
-/* CPU OF node matching */
-struct device_node *of_get_cpu_node(int cpu, unsigned int *thread);
-
 #endif /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 
-- 
1.8.1.2


