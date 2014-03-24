Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaCXNLt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Mar 2014 09:11:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:28182 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752419AbaCXNLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Mar 2014 09:11:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,720,1389772800"; 
   d="scan'208";a="478802398"
Date: Mon, 24 Mar 2014 09:11:04 -0400
From: Matthew Wilcox <willy@linux.intel.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] NVMe: silence GCC warning on 32 bit
Message-ID: <20140324131104.GC5777@linux.intel.com>
References: <1392714172-2712-1-git-send-email-geert@linux-m68k.org>
 <1392934261.15264.22.camel@x220>
 <alpine.LRH.2.03.1402210921010.4656@AMR>
 <1393925767.3038.23.camel@x220>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1393925767.3038.23.camel@x220>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 04, 2014 at 10:36:07AM +0100, Paul Bolle wrote:
> Also note that it's actually not clear to me why these warnings only
> trigger on 32 bit. I guess there's some int/long conversion lurking
> somewhere. I haven't found it. 

I bet you're using a different revision of the compiler on 32 and 64 bit.
Different gcc revisions have different abilities to track initialisation.
