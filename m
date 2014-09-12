Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189AbaILWO1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 18:14:27 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51941 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752884AbaILWO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 18:14:26 -0400
Date: Fri, 12 Sep 2014 18:14:23 -0400 (EDT)
Message-Id: <20140912.181423.1831537443587796533.davem@davemloft.net>
To: hock.leong.kweh@intel.com
Cc: peppe.cavallaro@st.com, rayagond@vayavyalabs.com, vbridgers2013@gmail.com,
        srinivas.kandagatla@st.com, wens@csie.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, boon.leong.ong@intel.com
Subject: Re: [PATCH v2 3/4] net: stmmac: add support for Intel Quark X1000
From: David Miller <davem@davemloft.net>
In-Reply-To: <07ca9d2c89cf4f01037c98e3314dd035e4d2ee34.1410416224.git.hock.leong.kweh@intel.com>
References: <cover.1410416223.git.hock.leong.kweh@intel.com>
	<cover.1410416223.git.hock.leong.kweh@intel.com>
	<07ca9d2c89cf4f01037c98e3314dd035e4d2ee34.1410416224.git.hock.leong.kweh@intel.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 12 Sep 2014 15:14:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Kweh Hock Leong <hock.leong.kweh@intel.com>
Date: Thu, 11 Sep 2014 16:38:39 +0800

> +		if ((!strcmp(quark_x1000_phy_info[i].board_name, board_name)) &&
> +		    quark_x1000_phy_info[i].pci_func_num == func_num)

It is entirely erroneous to identify a device by it's _PHYSICAL_ geographic
location on the PCI bus.

Please get rid of this PCI function number comparison and if necessary
find another means of identification.
