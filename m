Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755154AbaIPTAl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 15:00:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:57073 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754540AbaIPTAj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 15:00:39 -0400
Date: Tue, 16 Sep 2014 15:00:37 -0400 (EDT)
Message-Id: <20140916.150037.1715537913178712290.davem@davemloft.net>
To: hock.leong.kweh@intel.com
Cc: peppe.cavallaro@st.com, rayagond@vayavyalabs.com, vbridgers2013@gmail.com,
        srinivas.kandagatla@st.com, wens@csie.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, boon.leong.ong@intel.com
Subject: Re: [PATCH v2 3/4] net: stmmac: add support for Intel Quark X1000
From: David Miller <davem@davemloft.net>
In-Reply-To: <F54AEECA5E2B9541821D670476DAE19C2B7E99A7@PGSMSX102.gar.corp.intel.com>
References: <07ca9d2c89cf4f01037c98e3314dd035e4d2ee34.1410416224.git.hock.leong.kweh@intel.com>
	<20140912.181423.1831537443587796533.davem@davemloft.net>
	<F54AEECA5E2B9541821D670476DAE19C2B7E99A7@PGSMSX102.gar.corp.intel.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 16 Sep 2014 12:00:39 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Kweh, Hock Leong" <hock.leong.kweh@intel.com>
Date: Mon, 15 Sep 2014 12:42:03 +0000

> The only things to differentiate them is PCI BUS DEVICE FUNCTION
> (Bus:Dev:Func) number which are fix numbers 00:20:6 for port 1 and
> 00:20:7 for port 2 stated in Quark X1000 datasheet.

Match on the PCI device class, which must be PCI_CLASS_NETWORK_ETHERNET
or similar.

The pci_device_id used for probing supports matching on this directly.
.
