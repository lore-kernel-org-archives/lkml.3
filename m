Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965013Ab3GDIwg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 04:52:36 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:38297 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964923Ab3GDIvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 04:51:50 -0400
Message-ID: <51D535FC.1020100@st.com>
Date: Thu, 04 Jul 2013 09:44:44 +0100
From: Srinivas KANDAGATLA <srinivas.kandagatla@st.com>
Reply-To: srinivas.kandagatla@st.com
Organization: STMicroelectronics
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
Cc: netdev@vger.kernel.org, peppe.cavallaro@st.com, grant.likely@linaro.org,
        rob.herring@calxeda.com, rob@landley.net,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/3] extend stmmac DT support.
References: <1372770219-1643-1-git-send-email-srinivas.kandagatla@st.com> <20130703.160423.1285164466482391784.davem@davemloft.net>
In-Reply-To: <20130703.160423.1285164466482391784.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-7
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/07/13 00:04, David Miller wrote:

> You are going to have to fix up the following build warnings and resubmit:
> 
>   CC [M]  drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.o
> drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c: In function ¡stmmac_mdio_reset¢:
> drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:137:17: warning: unused variable ¡dev¢ [-Wunused-variable]
> drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c: In function ¡stmmac_mdio_register¢:
> drivers/net/ethernet/stmicro/stmmac/stmmac_mdio.c:200:17: warning: unused variable ¡dev¢ [-Wunused-variable]
Thanks Dave,
I will resubmit the patches with this warning fix.

Thanks,
srini
> 
> 
> Thanks.
> 

