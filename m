Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbaG3Mr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:47:57 -0400
Received: from mga11.intel.com ([192.55.52.93]:59623 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752615AbaG3Mrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:47:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="scan'208";a="569423924"
Date: Wed, 30 Jul 2014 20:47:50 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [delayed_fput] BUG: unable to handle kernel paging request at
 ffff8800122a0ad0
Message-ID: <20140730124750.GB7717@localhost>
References: <20140730035541.GD16537@localhost>
 <20140730111521.GB759@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730111521.GB759@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 04:15:21AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 30, 2014 at 11:55:41AM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> How does this manage to trip over a 2 year old commit now?

The bug is first discovered in linux-next, then the older kernel
releases (v3.15, v3.14, ...) are tested step by step, until it's found
to be introduced between v3.5 and v3.6. Then bisect can be started:

git bisect start v3.6 v3.5 --

Thanks,
Fengguang
