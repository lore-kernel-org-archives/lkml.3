Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752149AbaJFUh5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 16:37:57 -0400
Received: from mga14.intel.com ([192.55.52.115]:56026 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751264AbaJFUh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 16:37:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="396233125"
Date: Mon, 6 Oct 2014 13:37:31 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKP <lkp@01.org>, Yuanhan Liu <yuanhan.liu@intel.com>,
        linux-kernel@vger.kernel.org, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>
Subject: Re: [LKP] [x86LKP] PANIC: double fault, error_code:
 0xffffffffffffffff
Message-ID: <20141006203731.GF3264@tassilo.jf.intel.com>
References: <20141004134729.GB5214@wfg-t540p.sh.intel.com>
 <20141005063802.GE3264@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141005063802.GE3264@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I cannot reproduce with the config/kvm script. 

Well the user space in your initrd hangs after boot, but I presume that's some
different issue.

Do you have a different config or setup that shows it too?

-Andi
