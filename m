Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756177AbaEFUoW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 16:44:22 -0400
Received: from mga01.intel.com ([192.55.52.88]:64119 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754806AbaEFUoS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 16:44:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,998,1389772800"; 
   d="scan'208";a="534707977"
Date: Tue, 6 May 2014 13:44:17 -0700
From: Andi Kleen <ak@linux.intel.com>
To: josh@joshtriplett.org
Cc: David Miller <davem@davemloft.net>, eric.dumazet@gmail.com,
        andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506204417.GQ19657@tassilo.jf.intel.com>
References: <20140506164546.GB20536@cloud>
 <20140506.131752.740569380523989782.davem@davemloft.net>
 <20140506172106.GB20776@cloud>
 <20140506.132501.331724703594119414.davem@davemloft.net>
 <20140506201145.GC21332@cloud>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140506201145.GC21332@cloud>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And if you're asking for someone to help pay attention to bug reports so
> you don't have to, that's reasonable as well; just like you probably
> have a stock response for "that's a crazy distro kernel, ask them about
> it and not me", you could have a stock response for "that kernel has the
> crazy embedded option turned on, ask the embedded people about it and
> not me".  It doesn't just have to be *your* problem alone.

We could add a tainted flag for these configurations and a message at bootup
to make it obvious in bug reports.  Would that help?

-Andi
