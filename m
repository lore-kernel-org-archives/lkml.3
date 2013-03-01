Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751688Ab3CAKX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:23:58 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53339 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750907Ab3CAKX5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:23:57 -0500
Date: Fri, 1 Mar 2013 11:23:55 +0100
From: Michal Hocko <mhocko@suse.cz>
To: David Rientjes <rientjes@google.com>
Cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        dave@linux.vnet.ibm.com, mgorman@suse.de, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: +
 mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch added to
 -mm tree
Message-ID: <20130301102355.GC21443@dhcp22.suse.cz>
References: <20130228231025.9F11A5A410E@corp2gmr1-2.hot.corp.google.com>
 <20130301095716.GA21443@dhcp22.suse.cz>
 <alpine.DEB.2.02.1303010213140.23298@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1303010213140.23298@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 01-03-13 02:15:04, David Rientjes wrote:
> On Fri, 1 Mar 2013, Michal Hocko wrote:
> 
> > I have already asked about it in the original thread but didn't get any
> > answer. How can we get a soft lockup when all implementations of show_mem
> > call touch_nmi_watchdog?
> > 
> 
> Feel free to do s/soft lockups/irqs being disabled for an extremely long 
> time/.

OK, that sounds better. Sorry for being so persistent on this but soft
lockups tend to be a real issue for distribution kernels with
!CONFIG_PREEMPT so anything that fixes soft lockups raises a red flag.

Acked-by: Michal Hocko <mhocko@suse.cz>
-- 
Michal Hocko
SUSE Labs
