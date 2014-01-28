Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbaA1OON (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 09:14:13 -0500
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:36765 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754574AbaA1OOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 09:14:12 -0500
Date: Tue, 28 Jan 2014 19:43:56 +0530
From: Pratyush Anand <pratyush.anand@st.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Mohit Kumar <mohit.kumar@st.com>,
        <linux-kernel@vger.kernel.org>
Subject: Query: Phy: How to find consumer device on dt platform
Message-ID: <20140128141356.GC3519@pratyush-vbox>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kishon,

I have a phy driver which has to be used by two different consumer
driver, say pcie and sata.

I have a common set of registers, which need to be programmed
differently for PCIe and SATA during phy init/exit.

Therefore, in the init/exit routine of phy_ops, I need some way of
identifying that phy_init/exit has been called from PCIe driver or
SATA driver.

Please let me know, if a way already exist.

Regards
Pratyush
