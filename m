Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753767AbaJICUB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 22:20:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:40106 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067AbaJICTy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 22:19:54 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,682,1406617200"; 
   d="scan'208";a="585758443"
Date: Wed, 8 Oct 2014 19:19:48 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, Yuanhan Liu <yuanhan.liu@intel.com>,
        linux-kernel@vger.kernel.org, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>
Subject: Re: [LKP] [x86LKP] PANIC: double fault, error_code:
 0xffffffffffffffff
Message-ID: <20141009021948.GI3264@tassilo.jf.intel.com>
References: <20141004134729.GB5214@wfg-t540p.sh.intel.com>
 <20141005063802.GE3264@tassilo.jf.intel.com>
 <20141006203731.GF3264@tassilo.jf.intel.com>
 <20141007113311.GD16301@wfg-t540p.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141007113311.GD16301@wfg-t540p.sh.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> As the table shows, it's not an easily reproducible bug -- the possibility is
> less than 10%:

I think i found the problem. Thanks. Hopefully tests will pass now.

-Andi
