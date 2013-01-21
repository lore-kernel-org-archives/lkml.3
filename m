Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753605Ab3AUVun (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 16:50:43 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:50018 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751795Ab3AUVul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 16:50:41 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Schocher <hs@denx.de>
Subject: Re: [PATCH 11/15] mtd: davinci_nand: fix OF support
Date: Mon, 21 Jan 2013 21:50:21 +0000
User-Agent: KMail/1.12.2 (Linux/3.7.0-7-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        arm@kernel.org, Sekhar Nori <nsekhar@ti.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        David Woodhouse <David.Woodhouse@intel.com>
References: <1358788568-11137-1-git-send-email-arnd@arndb.de> <1358788568-11137-12-git-send-email-arnd@arndb.de> <50FDB509.9030004@denx.de>
In-Reply-To: <50FDB509.9030004@denx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201301212150.21659.arnd@arndb.de>
X-Provags-ID: V02:K0:N9kt4PEDtVPZq6Btv4hLGzE/vs42t5uRBHMSDxBqfcQ
 hS0a3RGWamOD8HBQgEWgdn8IqnlkB54IyJ1+HGYtdCrkyg1iIb
 eKcljyGwypWJePl1mFAMd0qRLtHofpOQOre6q8gE7WrxZt7vXG
 5iGSj5kK/JtF1GwEZoopqy8Ci5oZTinxbR2wdgfrKUvfufZdvB
 i0jj7lvdHePR5yTD/qDOWl83DzkLsh9Ow1w6HjBuuLdK6juYcF
 1anAeLqe0S9dPADMmpAwOm/7+gA2rTudRYJsHv7gSYBujKe17C
 Kcp6O7EWUpc6YYz/C4rxn6d7wgfORFRa3JyzJcArtnx6a2ztjR
 TMONiQfRpOO84L6/AHMo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 January 2013, Heiko Schocher wrote:
> Already fixed here:
> http://lists.infradead.org/pipermail/linux-mtd/2013-January/045366.html
> 

Ok, thanks for the confirmation. I had only checked -rc4, not any newer
snapshot.

	Arnd
