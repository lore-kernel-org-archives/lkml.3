Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751889AbaBLECA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 23:02:00 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:50125 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776AbaBLEB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 23:01:59 -0500
Date: Tue, 11 Feb 2014 20:01:43 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Andi Kleen <andi@firstfloor.org>
cc: Luiz Capitulino <lcapitulino@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        mtosatti@redhat.com, mgorman@suse.de, aarcange@redhat.com,
        riel@redhat.com
Subject: Re: [PATCH 0/4] hugetlb: add hugepagesnid= command-line option
In-Reply-To: <20140212023711.GT11821@two.firstfloor.org>
Message-ID: <alpine.DEB.2.02.1402112000000.31912@chino.kir.corp.google.com>
References: <1392053268-29239-1-git-send-email-lcapitulino@redhat.com> <20140211211732.GS11821@two.firstfloor.org> <20140211163108.3136d55a@redhat.com> <20140212023711.GT11821@two.firstfloor.org>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Feb 2014, Andi Kleen wrote:

> > The real syntax is hugepagesnid=nid,nr-pages,size. Which looks straightforward
> > to me. I honestly can't think of anything better than that, but I'm open for
> > suggestions.
> 
> hugepages_node=nid:nr-pages:size,... ? 
> 

I think that if we actually want this support that it should behave like 
hugepages= and hugepagesz=, i.e. you specify a hugepagesnode= and, if 
present, all remaining hugepages= and hugepagesz= parameters act only on 
that node unless overridden by another hugepagesnode=.
