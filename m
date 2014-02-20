Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913AbaBTK4C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Feb 2014 05:56:02 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:9267 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752948AbaBTKxC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Feb 2014 05:53:02 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-2a-5305de8b54d6
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linaro-mm-sig@lists.linaro.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Arnd Bergmann <arnd@arndb.de>, Michal Nazarewicz <mina86@mina86.com>,
        Grant Likely <grant.likely@linaro.org>,
        Tomasz Figa <t.figa@samsung.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Laura Abbott <lauraa@codeaurora.org>, Rob Herring <robh+dt@kernel.org>,
        Olof Johansson <olof@lixom.net>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>,
        Tomasz Figa <tomasz.figa@gmail.com>, Kumar Gala <galak@codeaurora.org>,
        Nishanth Peethambaran <nishanth.p@gmail.com>,
        Marc <marc.ceeeee@gmail.com>, Josh Cartwright <joshc@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>, Paul Mackerras <paulus@samba.org>
Subject: [PATCH v4 4/7] of: document bindings for reserved-memory nodes
Date: Thu, 20 Feb 2014 11:52:44 +0100
Message-id: <1392893567-31623-5-git-send-email-m.szyprowski@samsung.com>
X-Mailer: git-send-email 1.7.9.5
In-reply-to: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
References: <1392893567-31623-1-git-send-email-m.szyprowski@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAAyXRW0iTYRwG8N5v3/ftczT4XFZvIhKDKAoPCy/ewg434SthBV4kQdTU4YzN
	w+ZEhcg8ofO0FuHwvHRBwxPLPIxKnVNHWrg2HKVOSi/STZvMYOgmsbz7wfN/eC7+DEfwgoxm
	cvOKJIo8sUxI88j5wzlnXL2bSk/8NHQahbSzXOSrqOagP28aAOqyfqVQs1dPocngGEDexloS
	jQ/sAPSlwstFo3U6Ltpz/iSQaX2JQvqaXhI5zO006reuctHQ5hSBDC47gbrnqigUbIlFn11+
	GvVZe7hI09JPouqPVi4KjZpItDVVQ6JBnYdERnMQoM1dG3kzBvd19gF8sK8F2PNSA7CjqZHA
	462rXNzgraKwyVhH45WlDzR+1/sMLx+uc7DTVkHhgeAWgZtDibjD3ARw07ARYL8p9l7kA15y
	tkSWWyxRJFx/zJNOTlQSBTZRiX3nOVkOps+rQQQD2SQYch5QRz4FF92DtBrwGAFrANC9u0+E
	AwFbT8DQ6+iwaVYE1dtqOuwoVg+gv5MMFzjsGg1r7Q3/CyfYFKgOuThhk+w5+CswA9SAYfgs
	hj2OS2FC9ixs1yaHLyLYVFjpXqWOpjA0tzooDeB3g2NGcFKiyipQZubIL8crxXKlKi8nPitf
	bgJHb/w7BgyzVy2AZYDwOD/DRaYLKHGxslRuAZDhCKP4I9+pdAE/W1xaJlHkP1KoZBKlBRBM
	RHQ5MLA21XDl2PIPQfOGLjCtOwzMq6893Hu1J89smxENZkvhSvsd7e2EEbLN9vZb143CpNSR
	Ao8VpUi3cxe4he83fFe2Mpzi8l1fispyq6wo7UlatEXsU60pFi9EPr37+0xMFMVL6Nhc0gb2
	Qzl2o6zFc79E8yiusU4/seAO+YWkUioWXeQolOJ/YIYPQ6QCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Grant Likely <grant.likely@linaro.org>

Reserved memory nodes allow for the reservation of static (fixed
address) regions, or dynamically allocated regions for a specific
purpose.

Signed-off-by: Grant Likely <grant.likely@linaro.org>
[joshc: Based on binding document proposed (in non-patch form) here:
 http://lkml.kernel.org/g/20131030134702.19B57C402A0@trevor.secretlab.ca
 adapted to support #memory-region-cells]
Signed-off-by: Josh Cartwright <joshc@codeaurora.org>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
---
 .../bindings/reserved-memory/reserved-memory.txt   |  138 ++++++++++++++++++++
 1 file changed, 138 insertions(+)
 create mode 100644 Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt

diff --git a/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt b/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
new file mode 100644
index 000000000000..a606ce90c9c4
--- /dev/null
+++ b/Documentation/devicetree/bindings/reserved-memory/reserved-memory.txt
@@ -0,0 +1,138 @@
+*** Reserved memory regions ***
+
+Reserved memory is specified as a node under the /reserved-memory node.
+The operating system shall exclude reserved memory from normal usage
+one can create child nodes describing particular reserved (excluded from
+normal use) memory regions. Such memory regions are usually designed for
+the special usage by various device drivers.
+
+Parameters for each memory region can be encoded into the device tree
+with the following nodes:
+
+/reserved-memory node
+---------------------
+#address-cells, #size-cells (required) - standard definition
+    - Should use the same values as the root node
+#memory-region-cells (required) - dictates number of cells used in the child
+                                  nodes memory-region specifier
+ranges (required) - standard definition
+    - Should be empty
+
+/reserved-memory/ child nodes
+-----------------------------
+Each child of the reserved-memory node specifies one or more regions of
+reserved memory. Each child node may either use a 'reg' property to
+specify a specific range of reserved memory, or a 'size' property with
+optional constraints to request a dynamically allocated block of memory.
+
+Following the generic-names recommended practice, node names should
+reflect the purpose of the node (ie. "framebuffer" or "dma-pool"). Unit
+address (@<address>) should be appended to the name if the node is a
+static allocation.
+
+Properties:
+Requires either a) or b) below.
+a) static allocation
+   reg (required) - standard definition
+b) dynamic allocation
+   size (required) - length based on parent's #size-cells
+                   - Size in bytes of memory to reserve.
+   alignment (optional) - length based on parent's #size-cells
+                        - Address boundary for alignment of allocation.
+   alloc-ranges (optional) - prop-encoded-array (address, length pairs).
+                           - Specifies regions of memory that are
+                             acceptable to allocate from.
+
+If both reg and size are present, then the reg property takes precedence
+and size is ignored.
+
+Additional properties:
+compatible (optional) - standard definition
+    - may contain the following strings:
+        - shared-dma-pool: This indicates a region of memory meant to be
+          used as a shared pool of DMA buffers for a set of devices. It can
+          be used by an operating system to instanciate the necessary pool
+          management subsystem if necessary.
+        - vendor specific string in the form <vendor>,[<device>-]<usage>
+no-map (optional) - empty property
+    - Indicates the operating system must not create a virtual mapping
+      of the region as part of its standard mapping of system memory,
+      nor permit speculative access to it under any circumstances other
+      than under the control of the device driver using the region.
+reusable (optional) - empty property
+    - The operating system can use the memory in this region with the
+      limitation that the device driver(s) owning the region need to be
+      able to reclaim it back. Typically that means that the operating
+      system can use that region to store volatile or cached data that
+      can be otherwise regenerated or migrated elsewhere.
+
+Linux implementation note:
+- If a "linux,cma-default" property is present, then Linux will use the
+  region for the default pool of the contiguous memory allocator.
+
+Device node references to reserved memory
+-----------------------------------------
+Regions in the /reserved-memory node may be referenced by other device
+nodes by adding a memory-region property to the device node.
+
+memory-region (optional) - phandle, specifier pairs to children of /reserved-memory
+
+Example
+-------
+This example defines 3 contiguous regions are defined for Linux kernel:
+one default of all device drivers (named linux,cma@72000000 and 64MiB in size),
+one dedicated to the framebuffer device (named framebuffer@78000000, 8MiB), and
+one for multimedia processing (named multimedia-memory@77000000, 64MiB).
+
+/ {
+	#address-cells = <1>;
+	#size-cells = <1>;
+
+	memory {
+		reg = <0x40000000 0x40000000>;
+	};
+
+	reserved-memory {
+		#address-cells = <1>;
+		#size-cells = <1>;
+		ranges;
+
+		/* global autoconfigured region for contiguous allocations */
+		linux,cma {
+			compatible = "shared-dma-pool";
+			reusable;
+			#memory-region-cells = <0>;
+			size = <0x4000000>;
+			alignment = <0x2000>;
+			linux,cma-default;
+		};
+
+		display_reserved: framebuffer@78000000 {
+			#memory-region-cells = <0>;
+			reg = <0x78000000 0x800000>;
+		};
+
+		multimedia_reserved: multimedia@77000000 {
+			compatible = "acme,multimedia-memory";
+			#memory-region-cells = <1>;
+			reg = <0x77000000 0x4000000>;
+		};
+	};
+
+	/* ... */
+
+	fb0: video@12300000 {
+		memory-region = <&display_reserved>;
+		/* ... */
+	};
+
+	scaler: scaler@12500000 {
+		memory-region = <&multimedia_reserved 0xdeadbeef>;
+		/* ... */
+	};
+
+	codec: codec@12600000 {
+		memory-region = <&multimedia_reserved 0xfeebdaed>;
+		/* ... */
+	};
+};
-- 
1.7.9.5

