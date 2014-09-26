Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990AbaIZENw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 00:13:52 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37491 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbaIZENu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 00:13:50 -0400
Date: Fri, 26 Sep 2014 00:13:41 -0400 (EDT)
Message-Id: <20140926.001341.1361691136914532479.davem@davemloft.net>
To: b.galvani@gmail.com
Cc: netdev@vger.kernel.org, peppe.cavallaro@st.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org, carlo@caione.org,
        jerry.cao@amlogic.com, victor.wan@amlogic.com,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: net: stmmac glue layer for Amlogic Meson SoCs
From: David Miller <davem@davemloft.net>
In-Reply-To: <1411219757-9201-1-git-send-email-b.galvani@gmail.com>
References: <1411219757-9201-1-git-send-email-b.galvani@gmail.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Sep 2014 21:13:44 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Beniamino Galvani <b.galvani@gmail.com>
Date: Sat, 20 Sep 2014 15:29:15 +0200
> 
> the Ethernet controller available in Amlogic Meson6 and Meson8 SoCs is
> a Synopsys DesignWare MAC IP core, already supported by the stmmac
> driver.
> 
> These patches add a glue layer to the driver for the platform-specific
> settings required by the Amlogic variant.
> 
> This has been tested on a Amlogic S802 device with the initial Meson
> support submitted by Carlo Caione [1].
> 
> [1] http://lwn.net/Articles/612000/

Series applied to net-next, thanks.
