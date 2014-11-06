Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751441AbaKFPhN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 10:37:13 -0500
Received: from mail-ie0-f176.google.com ([209.85.223.176]:52613 "EHLO
	mail-ie0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaKFPhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 10:37:10 -0500
Date: Thu, 6 Nov 2014 15:36:59 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Maxime Coquelin <maxime.coquelin@st.com>
Cc: Kishon Vijay Abraham I <kishon@ti.com>,
        Gabriel FERNANDEZ <gabriel.fernandez@st.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Srinivas Kandagatla <srinivas.kandagatla@gmail.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@linaro.org>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com, Gabriel Fernandez <gabriel.fernandez@linaro.org>
Subject: Re: [PATCH v5 2/8] phy: miphy28lp: Add PHY header file for DT x
 Driver defines
Message-ID: <20141106153659.GD26543@x1>
References: <1415098284-11182-1-git-send-email-gabriel.fernandez@linaro.org>
 <1415098284-11182-3-git-send-email-gabriel.fernandez@linaro.org>
 <545B1C53.9010406@ti.com>
 <545B3FA4.8040109@st.com>
 <20141106112825.GC26543@x1>
 <545B6144.2020503@st.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <545B6144.2020503@st.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 06 Nov 2014, Maxime Coquelin wrote:
> On 11/06/2014 12:28 PM, Lee Jones wrote:
> >On Thu, 06 Nov 2014, Maxime Coquelin wrote:
> >
> >>Hi Kishon,
> >>On 11/06/2014 07:59 AM, Kishon Vijay Abraham I wrote:
> >>>Hi,
> >>>
> >>>On Tuesday 04 November 2014 04:21 PM, Gabriel FERNANDEZ wrote:
> >>>>This provides the shared header file which will be reference from both
> >>>>PHY driver and its associated Device Tree node(s).
> >>>>
> >>>>Signed-off-by: Gabriel Fernandez <gabriel.fernandez@linaro.org>
> >>>>---
> >>>>  include/dt-bindings/phy/phy.h | 18 ++++++++++++++++++
> >>>I don't see this being used in device tree file. Are you planning to add this
> >>>after -rc1 is tagged. Or else I have to create a separate branch for this file
> >>>which will be merged by both me and the dt maintainer. Let me know.
> >>I think we don't need to create a branch we will merged by both of us.
> >>
> >>What we can do that both of us apply this patch in our trees.
> >>It will avoid dependencies on each others.
> >>
> >>What do you think?
> >This makes no sense to me.  Can you find another way to explain this
> >please?
> 
> I apply the patch on my STi tree.
> Kishon applies the patch on his phy tree.
> 
> At the end, both STi and phy branches will be merged in Linus tree,
> with no conflicts.
> 
> This is what we are doing for the STiH407 reset DT bindings with Philipp Z.

If you do that, you will almost certainly get conflicts.  The commits
have to share the same SHA1 for Git to know for sure that they are the
same patch.  One of you needs to create a branch and tag it.  The
other can then merge the tag _then_ you won't get conflicts.

> >>>Thanks
> >>>Kishon
> >>>>  1 file changed, 18 insertions(+)
> >>>>  create mode 100644 include/dt-bindings/phy/phy.h
> >>>>
> >>>>diff --git a/include/dt-bindings/phy/phy.h b/include/dt-bindings/phy/phy.h
> >>>>new file mode 100644
> >>>>index 0000000..e8c6a3f
> >>>>--- /dev/null
> >>>>+++ b/include/dt-bindings/phy/phy.h
> >>>>@@ -0,0 +1,18 @@
> >>>>+/*
> >>>>+ *
> >>>>+ * This header provides constants for the phy framework
> >>>>+ *
> >>>>+ * Copyright (C) 2014 STMicroelectronics
> >>>>+ * Author: Gabriel Fernandez <gabriel.fernandez@st.com>
> >>>>+ * License terms:  GNU General Public License (GPL), version 2
> >>>>+ */
> >>>>+
> >>>>+#ifndef _DT_BINDINGS_PHY
> >>>>+#define _DT_BINDINGS_PHY
> >>>>+
> >>>>+#define PHY_TYPE_SATA		1
> >>>>+#define PHY_TYPE_PCIE		2
> >>>>+#define PHY_TYPE_USB2		3
> >>>>+#define PHY_TYPE_USB3		4
> >>>>+
> >>>>+#endif /* _DT_BINDINGS_PHY */
> >>>>
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
