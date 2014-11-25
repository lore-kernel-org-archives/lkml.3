Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409AbaKYQeP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 11:34:15 -0500
Received: from static.88-198-71-155.clients.your-server.de ([88.198.71.155]:48211
	"EHLO socrates.bennee.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbaKYQeM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 11:34:12 -0500
From: =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>
To: kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kvmarm@lists.cs.columbia.edu, christoffer.dall@linaro.org,
        marc.zyngier@arm.com, peter.maydell@linaro.org, agraf@suse.de
Cc: jan.kiszka@siemens.com, dahi@linux.vnet.ibm.com, r65777@freescale.com,
        bp@suse.de, pbonzini@redhat.com,
        =?UTF-8?q?Alex=20Benn=C3=A9e?= <alex.bennee@linaro.org>,
        Gleb Natapov <gleb@kernel.org>,
        linux-api@vger.kernel.org (open list:ABI/API),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/7] KVM: add commentary for kvm_debug_exit_arch struct
Date: Tue, 25 Nov 2014 16:09:59 +0000
Message-Id: <1416931805-23223-2-git-send-email-alex.bennee@linaro.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
References: <1416931805-23223-1-git-send-email-alex.bennee@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 127.0.0.1
X-SA-Exim-Mail-From: alex.bennee@linaro.org
X-SA-Exim-Scanned: No (on socrates.bennee.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bring into line with the commentary for the other structures and their
KVM_EXIT_* cases.

Signed-off-by: Alex Bennée <alex.bennee@linaro.org>

diff --git a/include/uapi/linux/kvm.h b/include/uapi/linux/kvm.h
index 6076882..523f476 100644
--- a/include/uapi/linux/kvm.h
+++ b/include/uapi/linux/kvm.h
@@ -226,6 +226,7 @@ struct kvm_run {
 			__u32 count;
 			__u64 data_offset; /* relative to kvm_run start */
 		} io;
+		/* KVM_EXIT_DEBUG */
 		struct {
 			struct kvm_debug_exit_arch arch;
 		} debug;
-- 
2.1.3

