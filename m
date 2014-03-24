Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaCXGJm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:09:42 -0400
Received: from mga01.intel.com ([192.55.52.88]:17170 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751508AbaCXGJj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:09:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,719,1389772800"; 
   d="scan'208";a="505220769"
Date: Mon, 24 Mar 2014 02:09:35 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: liaohengquan1986 <liaohengquan1986@163.com>
Cc: "Keith Busch" <keith.busch@intel.com>,
        "Alexander Gordeev" <agordeev@redhat.com>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: Re: A question about NVMe's nvme-irq
Message-ID: <20140324060935.GB5777@linux.intel.com>
References: <cover.1390897693.git.agordeev@redhat.com>
 <20140311150841.GA25564@dhcp-26-207.brq.redhat.com>
 <196070e8.d690.144bb7e553f.Coremail.liaohengquan1986@163.com>
 <20140313192045.GD6091@linux.intel.com>
 <785daaf7.5696.144e2af49b0.Coremail.liaohengquan1986@163.com>
 <20140321201109.GC5705@linux.intel.com>
 <42744e02.6f7d.144f1b148b3.Coremail.liaohengquan1986@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <42744e02.6f7d.144f1b148b3.Coremail.liaohengquan1986@163.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 09:25:31AM +0800, liaohengquan1986 wrote:
> 
> 
> In our server environment , The  mistakenly returning  IRQ_NONE will  make the OS(suse11 sp3) crush, should we fix it up? if yes, how?

You should raise this with SUSE.
