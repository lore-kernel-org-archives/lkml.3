Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758260Ab3ETWo0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 May 2013 18:44:26 -0400
Received: from mga01.intel.com ([192.55.52.88]:63454 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757216Ab3ETWoZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 May 2013 18:44:25 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,711,1363158000"; 
   d="scan'208";a="337275502"
Date: Mon, 20 May 2013 15:44:24 -0700 (PDT)
From: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
X-X-Sender: jbrandeb@jbrandeb-cp1.jf.intel.com
To: Or Gerlitz <or.gerlitz@gmail.com>
cc: Eliezer Tamir <eliezer.tamir@linux.intel.com>,
        Dave Miller <davem@davemloft.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Don Skidmore <donanld.c.skidmore@intel.com>,
        e1000-devel@lists.sourceforge.net,
        Willem de Bruijn <willemb@google.com>,
        Andi Kleen <andi@firstfloor.org>, HPA <hpa@zytor.com>,
        Eliezer Tamir <eliezer@tamir.org.il>
Subject: Re: [PATCH v2 net-next 0/4] net: low latency Ethernet device
 polling
In-Reply-To: <CAJZOPZJzVykmBH5FFQBVuztAFGRMOPT-GKABiewG6b4pnKVUeA@mail.gmail.com>
Message-ID: <alpine.LRH.2.03.1305201544180.10213@intel.com>
References: <20130519102525.12527.83301.stgit@ladj378.jer.intel.com> <CAJZOPZJzVykmBH5FFQBVuztAFGRMOPT-GKABiewG6b4pnKVUeA@mail.gmail.com>
User-Agent: Alpine 2.03 (LRH 1266 2009-07-14)
ReplyTo: "Brandeburg, Jesse" <jesse.brandeburg@intel.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 19 May 2013, Or Gerlitz wrote:
> On Sun, May 19, 2013 at 1:25 PM, Eliezer Tamir
> <eliezer.tamir@linux.intel.com> wrote:
> > This is an updated version of the code we posted on February.
> 
> Last time you've placed a copy of the patchset in the rfc branch of
> git://github.com/jbrandeb/lls.git  - can you repost there V2 too?

done, sorry for the dup, the first post got html munged by gmail web 
interface.

the latest set (the v3 changes) were posted to
the rfcv2 branch on git://github.com/jbrandeb/lls.git
