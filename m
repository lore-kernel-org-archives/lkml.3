Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751442Ab3CAKPJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Mar 2013 05:15:09 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:64241 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043Ab3CAKPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Mar 2013 05:15:07 -0500
Date: Fri, 1 Mar 2013 02:15:04 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Michal Hocko <mhocko@suse.cz>
cc: akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        dave@linux.vnet.ibm.com, mgorman@suse.de, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: + mm-show_mem-suppress-page-counts-in-non-blockable-contexts.patch
 added to -mm tree
In-Reply-To: <20130301095716.GA21443@dhcp22.suse.cz>
Message-ID: <alpine.DEB.2.02.1303010213140.23298@chino.kir.corp.google.com>
References: <20130228231025.9F11A5A410E@corp2gmr1-2.hot.corp.google.com> <20130301095716.GA21443@dhcp22.suse.cz>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 1 Mar 2013, Michal Hocko wrote:

> I have already asked about it in the original thread but didn't get any
> answer. How can we get a soft lockup when all implementations of show_mem
> call touch_nmi_watchdog?
> 

Feel free to do s/soft lockups/irqs being disabled for an extremely long 
time/.

> I do agree with the change but the above justification seems misleading.
> Can we just remove the information because it is costly and doesn't give
> us anything relevant to debug allocation failures?
> 

I believe I have already said yes, that all pertinent information is 
already there and I do not believe this additional information 
continuously spewed to the kernel log is helpful in debugging VM issues or 
understanding why the oom condition exists.
