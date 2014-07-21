Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaGUFT3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 01:19:29 -0400
Received: from mga11.intel.com ([192.55.52.93]:11894 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbaGUFT2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 01:19:28 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,698,1400050800"; 
   d="scan'208";a="572876820"
Date: Sun, 20 Jul 2014 22:19:27 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Jet Chen <jet.chen@intel.com>
Cc: Su Tao <tao.su@intel.com>, Aaron Lu <aaron.lu@intel.com>,
        Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Tree sweep] BUG: sleeping function called from invalid context
 at include/linux/highmem.h:58
Message-ID: <20140721051927.GR5803@tassilo.jf.intel.com>
References: <53CC6872.70402@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <53CC6872.70402@intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 21, 2014 at 09:10:10AM +0800, Jet Chen wrote:
> Hi Andi,
> 
> 0day kernel testing robot got the below dmesg and the first bad commit is

Thanks. That branch is not quite ready yet.

-Andi
