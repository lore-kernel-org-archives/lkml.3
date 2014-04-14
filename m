Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753367AbaDNHks (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 03:40:48 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:39237 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001AbaDNHkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 03:40:42 -0400
X-AuditID: cbfee68d-b7fcd6d00000315b-ad-534b90f4f63b
From: Jungseok Lee <jays.lee@samsung.com>
To: linux-arm-kernel@lists.infradead.org, kvmarm@lists.cs.columbia.edu,
        Catalin.Marinas@arm.com, Marc Zyngier <Marc.Zyngier@arm.com>,
        Christoffer Dall <christoffer.dall@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        sungjinn.chung@samsung.com, Arnd Bergmann <arnd@arndb.de>,
        kgene.kim@samsung.com, ilho215.lee@samsung.com
Subject: [PATCH 2/8] arm/arm64: KVM: Fix line length exceeding 80 characters
Date: Mon, 14 Apr 2014 16:40:36 +0900
Message-id: <000001cf57b4$d3450780$79cf1680$@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-index: Ac9XrOqSEvxwdIZkRuyR0VuAzwiv7Q==
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrBIsWRmVeSWpSXmKPExsVy+t8zY92vE7yDDd4+ZLT4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosPM1YyOnB7rJm3
	htHj969JjB53ru1h8zi/aQ2zx+Yl9R59W1YxenzeJBfAHsVlk5Kak1mWWqRvl8CVsaqxh6Xg
	OFvF14c/WRoY17B2MXJwSAiYSKz/nNHFyAlkiklcuLeerYuRi0NIYBmjxJb3y1ggEiYStzta
	oRKLGCXe318O5fxhlNi0ZxM7SBWbgKbEo7s97CAJEYEdjBKT1y5iBXGYBU4wSiy9s5YVpEpY
	wEeicfoWNhCbRUBV4szpaWBxXgFLiYlbFkHZghI/Jt8D280soCWxfudxJghbXmLzmrfMEDcp
	SOw4+5oRxBYR0JPYePEKM0SNiMS+F+8YIWr+sks862OE2CUg8W3yIRaIn2UlNh2AGiMpcXDF
	DZYJjGKzkGyehWTzLCSbZyHZsICRZRWjaGpBckFxUnqRoV5xYm5xaV66XnJ+7iZGSCz37mC8
	fcD6EGMy0PqJzFKiyfnAVJBXEm9obGZkYWpiamxkbmlGmrCSOG/Sw6QgIYH0xJLU7NTUgtSi
	+KLSnNTiQ4xMHJxSDYxr02bM8jmnd0X5jOWvNCmRFcs687Z8XG536YdwsRKvUCk3/7WrYv+f
	fOyxqhf+lfyu+Vkzu79U2+wnmffuvfPYlSxU2NCa4Wd+rMhv+ROF4tVF9nveVseefWNV8ko/
	I2hPu92S585tPb/+rdJ41ZtgJCZguZ7Vb8k1lkN8/xrkde8t4Gp8YqnEUpyRaKjFXFScCABt
	Tu90+wIAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOKsWRmVeSWpSXmKPExsVy+t9jAd0vE7yDDd5Psbb4O+kYu8X7ZT2M
	Fi9e/2O0OPpvIaNF74KrbBYfTx1nt9j0+BqrxeVdc9gsZpzfx2Tx984/NosPM1YyOnB7rJm3
	htHj969JjB53ru1h8zi/aQ2zx+Yl9R59W1YxenzeJBfAHtXAaJORmpiSWqSQmpecn5KZl26r
	5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdKSSQlliTilQKCCxuFhJ3w7ThNAQN10L
	mMYIXd+QILgeIwM0kLCOMWNVYw9LwXG2iq8Pf7I0MK5h7WLk5JAQMJG43dHKBmGLSVy4tx7I
	5uIQEljEKPH+/nIo5w+jxKY9m9hBqtgENCUe3e1hB0mICOxglJi8dhEriMMscIJRYumdtWBz
	hQV8JBqnbwGbyyKgKnHm9DSwOK+ApcTELYugbEGJH5PvsYDYzAJaEut3HmeCsOUlNq95ywxx
	k4LEjrOvGUFsEQE9iY0XrzBD1IhI7HvxjnECo8AsJKNmIRk1C8moWUhaFjCyrGIUTS1ILihO
	Ss811CtOzC0uzUvXS87P3cQIThbPpHYwrmywOMQowMGoxMObsN0zWIg1say4MvcQowQHs5II
	77YMr2Ah3pTEyqrUovz4otKc1OJDjMlAn05klhJNzgcmsrySeENjEzMjSyMzCyMTc3PShJXE
	eQ+0WgcKCaQnlqRmp6YWpBbBbGHi4JRqYBR4fremVOJDlWpEfsjPTW1fV+0y0Z/5Z43rV1eD
	S/yTT3pPCrF4vs+j0Snfsj0jnzHlbEX37CNde9ZMeGeU2yy8/jVzZn7Rn7rTDzb+OP7D7f9y
	9fuSmh/8mrgWipmvm7HWgpdRyYids5Rtmpv8yhbvywl/Tge+F555W7+N64rjbn3BnPUWWUos
	xRmJhlrMRcWJAElMBMZaAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch deals with checkpatch complaint as fixing line length
exceeding 80 characters.

WARNING: line over 80 characters

Signed-off-by: Jungseok Lee <jays.lee@samsung.com>
Reviewed-by: Sungjinn Chung <sungjinn.chung@samsung.com>
---
 arch/arm/kvm/mmu.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/kvm/mmu.c b/arch/arm/kvm/mmu.c
index 80bb1e6..e0d4f24 100644
--- a/arch/arm/kvm/mmu.c
+++ b/arch/arm/kvm/mmu.c
@@ -563,8 +563,8 @@ void kvm_free_stage2_pgd(struct kvm *kvm)
 	kvm->arch.pgd = NULL;
 }
 
-static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache *cache,
-			     phys_addr_t addr)
+static pmd_t *stage2_get_pmd(struct kvm *kvm, struct kvm_mmu_memory_cache
+			     *cache, phys_addr_t addr)
 {
 	pgd_t *pgd;
 	pud_t *pud;
-- 
1.7.10.4


