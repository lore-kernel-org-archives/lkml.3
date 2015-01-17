Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752828AbbAQBKN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jan 2015 20:10:13 -0500
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:13228 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216AbbAQBKM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jan 2015 20:10:12 -0500
X-IronPort-AV: E=Sophos;i="5.09,414,1418112000"; 
   d="scan'208";a="55005743"
Message-ID: <54B9B66C.70308@broadcom.com>
Date: Fri, 16 Jan 2015 17:10:04 -0800
From: Ray Jui <rjui@broadcom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <linux-kernel@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>
Subject: How to handle access to multiple PHYs through MDIO
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Our SoC, Cygnus, uses a generic MDC/MDIO controller to talk to various
PHYs, including 2 x Ethernet GPHY, 2 x PCIe Serdes, and 3 x USB PHYs. In
this case, how should I work out a generic PHY driver to handle this?

I notice that most generic PHY drivers are in drivers/phy/*, but
Ethernet seems to have its own interface of talking to a PHY through
MDIO (drivers/net/phy/*).

I need a single driver to handle these so there isn't any race condition
for this single MDIO access in our system.

Thanks,

Ray
