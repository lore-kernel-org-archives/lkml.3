Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933333Ab3GCXE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 19:04:29 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:39025 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933096Ab3GCXE1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 19:04:27 -0400
Date: Wed, 03 Jul 2013 16:04:23 -0700 (PDT)
Message-Id: <20130703.160423.1285164466482391784.davem@davemloft.net>
To: srinivas.kandagatla@st.com
Cc: netdev@vger.kernel.org, peppe.cavallaro@st.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] extend stmmac DT support.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1372770219-1643-1-git-send-email-srinivas.kandagatla@st.com>
References: <1372770219-1643-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id r63N4bhY018507

From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Date: Tue,  2 Jul 2013 14:03:39 +0100

> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> 
> Hi Peppe,
> 
> Thankyou for the comments on RFC patches.
> 
> This patch series adds support to new gmac versions 3.6.10 and 3.710, these
> versions of IP are integrated into ST STiH415/STiH416 SOCs.
> This patchset also adds phy reset capablity to stmmac-mdio driver via DT.
> 
> Changes since RFC:
> 	- re-use existing compatible strings to select right properties.
> 	- clean up reset callback support so that DT is not parsed everytime.

You are going to have to fix up the following build warnings and resubmit:

  CC [M]  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o
drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c: In function ¡stmmac_mdio_reset¢:
drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:137:17: warning: unused variable ¡dev¢ [-Wunused-variable]
drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c: In function ¡stmmac_mdio_register¢:
drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:200:17: warning: unused variable ¡dev¢ [-Wunused-variable]


Thanks.
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
