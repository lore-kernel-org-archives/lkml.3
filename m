Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471AbaIHJPl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:15:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753093AbaIHJPk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:15:40 -0400
Date: Mon, 8 Sep 2014 11:15:37 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jet Chen <jet.chen@intel.com>, Su Tao <tao.su@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>, LKP <lkp@01.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [dummy-irq] genirq: Flags mismatch irq 0. 00000080 (dummy_irq)
 vs. 00015a20 (timer)
In-Reply-To: <20140908091248.GA23776@localhost>
Message-ID: <alpine.LNX.2.00.1409081114290.5523@pobox.suse.cz>
References: <20140908091248.GA23776@localhost>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 8 Sep 2014, Fengguang Wu wrote:

> This patch is found to trigger a call trace dump during kernel boot.
> Can it be possibly fixed? Thanks!

Hi Fengguang,

from the dmesg it's obvious that dummy-irq is requesting IRQ#0 by default. 
This has been fixed back in 2013 via commit a7b594b490. Are you sure you 
have that commit applied?

Thanks,

-- 
Jiri Kosina
SUSE Labs
