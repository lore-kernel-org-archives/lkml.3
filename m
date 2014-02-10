Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941AbaBJWk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 17:40:58 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:56579 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752394AbaBJWkz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 17:40:55 -0500
Date: Mon, 10 Feb 2014 14:40:54 -0800 (PST)
Message-Id: <20140210.144054.2066120014050984537.davem@davemloft.net>
To: srinivas.kandagatla@st.com
Cc: netdev@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        stuart.menefy@st.com, peppe.cavallaro@st.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com
Subject: Re: [PATCH v2 1/3] net: stmmac:sti: Add STi SOC glue driver.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1391770525-24349-1-git-send-email-srinivas.kandagatla@st.com>
References: <1391770455-24291-1-git-send-email-srinivas.kandagatla@st.com>
	<1391770525-24349-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <srinivas.kandagatla@st.com>
Date: Fri, 7 Feb 2014 10:55:25 +0000

> +		if (dwmac->interface == PHY_INTERFACE_MODE_MII ||
> +			dwmac->interface == PHY_INTERFACE_MODE_GMII) {

This is not indented correctly, the first character on the second line should
line up exactly at the column after the openning parenthesis on the first
line.

The objective is not to indent using only TAB characters, which you
are doing here.

Rather, the objective is to use the appropriate number of TAB _and_
space characters necessary to reach the proper column.

> +		const char *rs;
> +		err = of_property_read_string(np, "st,tx-retime-src", &rs);

Please add an empty line after the local variable declaration.

> +		if (!strcasecmp(rs, "clk_125"))
> +			dwmac->is_tx_retime_src_clk_125 = true;
> +
> +	}

That empty line is superfluous, please delete it.
