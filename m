Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629AbaG3Mjo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 08:39:44 -0400
Received: from mga11.intel.com ([192.55.52.93]:58540 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755592AbaG3Mjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 08:39:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,764,1400050800"; 
   d="scan'208";a="569421115"
Date: Wed, 30 Jul 2014 20:39:33 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: David Herrmann <dh.herrmann@gmail.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [fs] BUG: unable to handle kernel NULL pointer dereference at
 00000104
Message-ID: <20140730123933.GA7717@localhost>
References: <20140730041235.GJ16537@localhost>
 <20140730111420.GA759@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140730111420.GA759@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 30, 2014 at 04:14:20AM -0700, Christoph Hellwig wrote:
> On Wed, Jul 30, 2014 at 12:12:35PM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > 0day kernel testing robot got the below dmesg and the first bad commit is
> 
> Where is this coming from?  Bloating struct file for device specific
> stuff really isn't acceptable anyway.

It's from this git tree:

git://people.freedesktop.org/~dvdhrm/linux fops

Thanks,
Fengguang
