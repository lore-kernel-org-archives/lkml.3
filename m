Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752056Ab3GBNKT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 09:10:19 -0400
Received: from eu1sys200aog121.obsmtp.com ([207.126.144.151]:36969 "EHLO
	eu1sys200aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750799Ab3GBNKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 09:10:17 -0400
X-Greylist: delayed 22901 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Jul 2013 09:10:16 EDT
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
To: netdev@vger.kernel.org
Cc: Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Srinivas Kandagatla <srinivas.kandagatla@st.com>
Subject: [PATCH v1 0/3] extend stmmac DT support.
Date: Tue,  2 Jul 2013 14:03:39 +0100
Message-Id: <1372770219-1643-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srinivas Kandagatla <srinivas.kandagatla@st.com>

Hi Peppe,

Thankyou for the comments on RFC patches.

This patch series adds support to new gmac versions 3.6.10 and 3.710, these
versions of IP are integrated into ST STiH415/STiH416 SOCs.
This patchset also adds phy reset capablity to stmmac-mdio driver via DT.

Changes since RFC:
	- re-use existing compatible strings to select right properties.
	- clean up reset callback support so that DT is not parsed everytime.

Thanks,
srini

Srinivas Kandagatla (3):
  dt:net:stmmac: Allocate platform data only if its NULL.
  dt:net:stmmac: Add support to dwmac version 3.610 and 3.710
  dt:net:stmmac: Add dt specific phy reset callback support.

 Documentation/devicetree/bindings/net/stmmac.txt   |   10 ++++
 drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c  |   50 +++++++++++++++++++-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   32 +++++++++++-
 include/linux/stmmac.h                             |    4 ++
 4 files changed, 91 insertions(+), 5 deletions(-)

-- 
1.7.6.5

