Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752540AbaEFScV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:32:21 -0400
Received: from mga02.intel.com ([134.134.136.20]:28247 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339AbaEFScU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:32:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,998,1389772800"; 
   d="scan'208";a="535751507"
Date: Tue, 6 May 2014 11:32:16 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: josh@joshtriplett.org, David Miller <davem@davemloft.net>,
        andi@firstfloor.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com
Subject: Re: [PATCH 08/24] net, diet: Make TCP metrics optional
Message-ID: <20140506183216.GM19657@tassilo.jf.intel.com>
References: <1399328773-6531-9-git-send-email-andi@firstfloor.org>
 <20140505.231229.136734008603421707.davem@davemloft.net>
 <20140506032114.GP2382@two.firstfloor.org>
 <20140505.232327.578134514220748085.davem@davemloft.net>
 <20140506155703.GA20391@cloud>
 <1399394359.15399.20.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399394359.15399.20.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> We simply can not compete with user space, as a programmer is free to
> keep what he really wants/needs.

Not true.

With my patches and LTO Linux can be competive with LWIP+socket layer.
(about 60K more text). And it's easier to use because it's just
the standard interface.

> I have started using linux on 386/486 pcs which had more than 2MB of
> memory, it makes me sad we want linux-3.16 to run on this kind of
> hardware, and consuming time to save few KB here and here.

Linux has always been a system from very small to big.
That's been one of its strengths. It is very adaptable.

Many subsystems are very configurable for this.
For example that is why we have both SLOB and SLUB.
That is why we have NOMMU MM and lots of other tuning 
knobs for small systems.

So if the other subsystems can do this, why should it be
impossible for networking?

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
