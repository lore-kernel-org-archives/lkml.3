Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751715AbaBHNHw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 08:07:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:31366 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750957AbaBHNHv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 08:07:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,806,1384329600"; 
   d="scan'208";a="471839403"
Date: Sat, 8 Feb 2014 21:07:49 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Filipe David Manana <fdmanana@gmail.com>
Cc: Chris Mason <clm@fb.com>, Tejun Heo <tj@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Subject: Re: [btrfs] BUG: unable to handle kernel NULL pointer dereference at
 0000000000000038
Message-ID: <20140208130749.GB16468@localhost>
References: <20140207023801.GC11051@localhost>
 <alpine.DEB.2.02.1402070213020.22146@chino.kir.corp.google.com>
 <20140207121038.GA1690@localhost>
 <52F4F755.4090503@fb.com>
 <CAL3q7H6ZRzXqaxF_DQbeiRdE_dy=62BjFHiBKt=YAiGgEeiCRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H6ZRzXqaxF_DQbeiRdE_dy=62BjFHiBKt=YAiGgEeiCRA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> If you disable CONFIG_BTRFS_FS_RUN_SANITY_TESTS, does it still crash?

Good idea! I've queued test jobs for that config. However sorry that
I'll be offline for the next 2 days. So please expect some delays.

Thanks,
Fengguang
