Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752801AbaEFSYF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 May 2014 14:24:05 -0400
Received: from mga11.intel.com ([192.55.52.93]:42703 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751134AbaEFSYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 May 2014 14:24:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,998,1389772800"; 
   d="scan'208";a="534592719"
Date: Tue, 6 May 2014 11:23:44 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, tom.zanussi@linux.intel.com
Subject: Re: [PATCH 06/24] net, diet: Use small UDP hash tables on small
 kernels
Message-ID: <20140506182344.GL19657@tassilo.jf.intel.com>
References: <1399328773-6531-1-git-send-email-andi@firstfloor.org>
 <1399328773-6531-7-git-send-email-andi@firstfloor.org>
 <1399386402.15399.11.camel@edumazet-glaptop2.roam.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399386402.15399.11.camel@edumazet-glaptop2.roam.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This patch has no effect on a small machine, because we already
> dynamically size this hash table.

Good point.

> 
> (The factor is one slot per 2MB of low memory)

Ok I need to fix that, because a single slot on a 2MB system 
is likely not enough.

-Andi
