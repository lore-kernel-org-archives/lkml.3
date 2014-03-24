Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386AbaCXGJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 02:09:22 -0400
Received: from mga02.intel.com ([134.134.136.20]:19711 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750760AbaCXGJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 02:09:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,719,1389772800"; 
   d="scan'208";a="506132599"
Date: Mon, 24 Mar 2014 02:09:01 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: liaohengquan1986 <liaohengquan1986@163.com>
Cc: "Keith Busch" <keith.busch@intel.com>,
        "Alexander Gordeev" <agordeev@redhat.com>,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org
Subject: Re: if  the NVMe driver has been validated on dual-cpu platform
Message-ID: <20140324060901.GA5777@linux.intel.com>
References: <cover.1390897693.git.agordeev@redhat.com>
 <20140311150841.GA25564@dhcp-26-207.brq.redhat.com>
 <196070e8.d690.144bb7e553f.Coremail.liaohengquan1986@163.com>
 <20140313192045.GD6091@linux.intel.com>
 <785daaf7.5696.144e2af49b0.Coremail.liaohengquan1986@163.com>
 <20140321201109.GC5705@linux.intel.com>
 <45840288.abae.144f2312ef0.Coremail.liaohengquan1986@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45840288.abae.144f2312ef0.Coremail.liaohengquan1986@163.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 24, 2014 at 11:45:13AM +0800, liaohengquan1986 wrote:
>                   I want to ask that if  the NVMe driver has been validated on dual-cpu platform?

I've run it on a dual socket platform.  Performance is better if the
application is running on the socket that the card is attached to :-)
