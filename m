Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752038AbaAOChv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 21:37:51 -0500
Received: from mail-yh0-f54.google.com ([209.85.213.54]:64997 "EHLO
	mail-yh0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802AbaAOCht (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 21:37:49 -0500
Date: Tue, 14 Jan 2014 18:37:45 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Dave Hansen <dave@sr71.net>
cc: Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        penberg@kernel.org
Subject: Re: [RFC][PATCH 2/9] mm: slub: abstract out double cmpxchg option
In-Reply-To: <52D5AEF7.6020707@sr71.net>
Message-ID: <alpine.DEB.2.02.1401141832420.32645@chino.kir.corp.google.com>
References: <20140114180042.C1C33F78@viggo.jf.intel.com> <20140114180046.C897727E@viggo.jf.intel.com> <alpine.DEB.2.10.1401141346310.19618@nuc> <52D5AEF7.6020707@sr71.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 14 Jan 2014, Dave Hansen wrote:

> > On Tue, 14 Jan 2014, Dave Hansen wrote:
> >> I found this useful to have in my testing.  I would like to have
> >> it available for a bit, at least until other folks have had a
> >> chance to do some testing with it.
> > 
> > I dont really see the point of this patch since we already have
> > CONFIG_HAVE_ALIGNED_STRUCT_PAGE to play with.
> 
> With the current code, if you wanted to turn off the double-cmpxchg abd
> get a 56-byte 'struct page' how would you do it?  Can you do it with a
> .config, or do you need to hack the code?
> 

If that's the intention of disabling this new config option, then it 
should probably mention the savings in the "help" section, similar to what
CONFIG_HAVE_ALIGNED_STRUCT_PAGE says.
