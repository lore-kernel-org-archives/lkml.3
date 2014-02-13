Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752089AbaBMV0D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Feb 2014 16:26:03 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:50242 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939AbaBMV0A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Feb 2014 16:26:00 -0500
Date: Thu, 13 Feb 2014 16:25:56 -0500 (EST)
Message-Id: <20140213.162556.2217483759096236481.davem@davemloft.net>
To: srinivas.kandagatla@st.com
Cc: netdev@vger.kernel.org, robh+dt@kernel.org, pawel.moll@arm.com,
        mark.rutland@arm.com, ijc+devicetree@hellion.org.uk,
        galak@codeaurora.org, rob@landley.net, linux@arm.linux.org.uk,
        stuart.menefy@st.com, peppe.cavallaro@st.com,
        devicetree@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        kernel@stlinux.com
Subject: Re: [PATCH v3 0/3] net: stmmac: Add STi GMAC ethernet
From: David Miller <davem@davemloft.net>
In-Reply-To: <1392112716-30803-1-git-send-email-srinivas.kandagatla@st.com>
References: <1391770455-24291-1-git-send-email-srinivas.kandagatla@st.com>
	<1392112716-30803-1-git-send-email-srinivas.kandagatla@st.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 13 Feb 2014 13:26:00 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: <srinivas.kandagatla@st.com>
Date: Tue, 11 Feb 2014 09:58:36 +0000

> Dave, Can I request you to take the first patch via net tree for v3.15, I can
> request Arnd or Olof to take the DT patches via the arm-soc tree for v3.15.

Since it's a new driver, I decided to add it to the plain 'net' tree.

Thanks.

