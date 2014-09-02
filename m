Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061AbaIBDxg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 23:53:36 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:52964 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832AbaIBDxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 23:53:34 -0400
X-AuditID: cbfee68f-f797f6d000001173-4e-54053f3b185c
From: Pankaj Dubey <pankaj.dubey@samsung.com>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Cc: robh+dt@kernel.org, will.deacon@arm.com, catalin.marinas@arm.com,
        naushad@samsung.com, thomas.ab@samsung.com,
        Pankaj Dubey <pankaj.dubey@samsung.com>
Subject: [RESEND PATCH] arm64: dts: add <dt-bindings/> symlink
Date: Tue, 02 Sep 2014 09:19:16 +0530
Message-id: <1409629756-14304-1-git-send-email-pankaj.dubey@samsung.com>
X-Mailer: git-send-email 1.7.9.5
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrJLMWRmVeSWpSXmKPExsWyRsSkWtfanjXEoO2jucX7ZT2MFvOPnGO1
	2PT4GqvF5V1z2Cw+Hf3ParFo6xd2i9a9R9gtOpYxWrz8eILFgdNjzbw1jB6bVnWyeWxeUu/R
	t2UVo8fnTXIBrFFcNimpOZllqUX6dglcGUtPHmAs2MhRcf/OfsYGxunsXYwcHBICJhJbVkp1
	MXICmWISF+6tZ+ti5OIQEljKKNG16QQTRMJEYuGPnWwgtpDAdEaJ52+rIYomMEkcnXCZFSTB
	JqAr8eT9XGYQW0QgReLB0xVgDcwCcxkl1k50ArGFBewkJk1YzwJiswioSvxa8Q6shlfAQ6Lv
	0zE2iIMUJOZMsgGZLyHQzS6x6/03doh6AYlvkw+xQNTISmw6wAxxm6TEwRU3WCYwCi5gZFjF
	KJpakFxQnJReZKxXnJhbXJqXrpecn7uJERjCp/8969/BePeA9SFGAQ5GJR5eiR8sIUKsiWXF
	lbmHGE2BNkxklhJNzgdGSl5JvKGxmZGFqYmpsZG5pZmSOO9CqZ/BQgLpiSWp2ampBalF8UWl
	OanFhxiZODilGhh7d53+4LT497nOzGnqa/K/hxW/X/vL1p1Hq1JxadCuG0f4BXQnuKYUXNEQ
	WeR4xeqT/0uT012yZzuOKAcbrOzdZBa61iCk/fXUZxUCZw/ydGryBzl/04rfmvzp188te1qD
	I/SVGvwv3vgrwvTzofH5lL8JnwVunHY99cpm4o7btf0qyzJqNgkrsRRnJBpqMRcVJwIAXBtW
	a1wCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprCIsWRmVeSWpSXmKPExsVy+t9jQV1re9YQg70H9SzeL+thtJh/5Byr
	xabH11gtLu+aw2bx6eh/VotFW7+wW7TuPcJu0bGM0eLlxxMsDpwea+atYfTYtKqTzWPzknqP
	vi2rGD0+b5ILYI1qYLTJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy
	8QnQdcvMAbpHSaEsMacUKBSQWFyspG+HaUJoiJuuBUxjhK5vSBBcj5EBGkhYw5ix9OQBxoKN
	HBX37+xnbGCczt7FyMkhIWAisfDHTjYIW0ziwr31YLaQwHRGiedvq7sYuYDsCUwSRydcZgVJ
	sAnoSjx5P5cZxBYRSJF48HQFWAOzwFxGibUTnUBsYQE7iUkT1rOA2CwCqhK/VrwDq+EV8JDo
	+3QMyOYAWqYgMWeSzQRG7gWMDKsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgmPkmfQOxlUN
	FocYBTgYlXh4JX6whAixJpYVV+YeYpTgYFYS4e0yZw0R4k1JrKxKLcqPLyrNSS0+xGgKtHwi
	s5Rocj4wfvNK4g2NTcxNjU0tTSxMzCyVxHkPtloHCgmkJ5akZqemFqQWwfQxcXBKNTAWbrFu
	LeQom1T5Pmo+expvaQLzfC6ZcytsksNd15fb5mceesq04LfbfZn/i1my/SWkbwhue7oil++6
	o/ZXr+JdNq53LA5azN6+aEl1o0xEhLrYo71XVc5YpdZnsvPt472nfuXo3aIlTNcvsK5J8+xp
	MMyc+HpfYdmxQ6qz3P4fnvcu96jr+cNKLMUZiYZazEXFiQBHH7EdpwIAAA==
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add symlink to include/dt-bindings from arch/arm64/boot/dts/include/ to
match the ones in ARM architectures so that preprocessed device
tree files can include various useful constant definitions.

See commit c58299aa8754 ("kbuild: create an "include chroot" for DT bindings")
merged in v3.10-rc1 for details.

CC: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Pankaj Dubey <pankaj.dubey@samsung.com>
---

Resubmitting this change as now it will be required for Samsung ARM64
based SoC.

Initial discussion can be found at here 
http://lists.infradead.org/pipermail/linux-arm-kernel/2014-January/228225.html

 arch/arm64/boot/dts/include/dt-bindings |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)
 create mode 120000 arch/arm64/boot/dts/include/dt-bindings

diff --git a/arch/arm64/boot/dts/include/dt-bindings b/arch/arm64/boot/dts/include/dt-bindings
new file mode 120000
index 0000000..68ae388
--- /dev/null
+++ b/arch/arm64/boot/dts/include/dt-bindings
@@ -0,0 +1 @@
+../../../../../include/dt-bindings
-- 
1.7.4.4

