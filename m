Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751353AbaKYTQV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 14:16:21 -0500
Received: from mga01.intel.com ([192.55.52.88]:44734 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750841AbaKYTQT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:16:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,457,1413270000"; 
   d="scan'208";a="637964339"
Date: Tue, 25 Nov 2014 11:14:16 -0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Kees Cook <keescook@chromium.org>, "Qian, Shijun" <shijun.qian@intel.com>
Cc: "Bernal Marin, Miguel" <miguel.bernal.marin@intel.com>,
        Yuanhan Liu <yuanhan.liu@intel.com>,
        LKML <linux-kernel@vger.kernel.org>, stable@vger.kernel.org
Subject: [stable] KASLR could not find suitable E820 region...
Message-ID: <20141125191416.GA4648@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kees,

We noticed the below boot errors in stable kernels 3.16.7 and 3.17.2
on real hardwares:

        early console in decompress_kernel
        KASLR could not find suitable E820 region...

        Decompressing Linux... Parsing ELF... Performing relocations... 

        32-bit relocation outside of kernel!

These kconfig options are enabled:

        CONFIG_RANDOMIZE_BASE=y
        CONFIG_RANDOMIZE_BASE_MAX_OFFSET=0x40000000

Before digging further, we'd like to ask for a quick answer that
whether they've been fixed by some commit in current mainline kernel?

Thanks,
Fengguang
