Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752005AbaAODNc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 22:13:32 -0500
Received: from mail-yh0-f47.google.com ([209.85.213.47]:50637 "EHLO
	mail-yh0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751600AbaAODN3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 22:13:29 -0500
Date: Tue, 14 Jan 2014 19:08:19 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Davidlohr Bueso <davidlohr@hp.com>
cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>, Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Davidlohr Bueso <davidlohr.bueso@hp.com>,
        David Gibson <david@gibson.dropbear.id.au>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Wanpeng Li <liwanp@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Hillf Danton <dhillf@gmail.com>, aswin@hp.com
Subject: Re: [PATCH v3 13/14] mm, hugetlb: retry if failed to allocate and
 there is concurrent user
In-Reply-To: <1389062214.9937.0.camel@buesod1.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.02.1401141906350.451@chino.kir.corp.google.com>
References: <1387349640-8071-1-git-send-email-iamjoonsoo.kim@lge.com> <1387349640-8071-14-git-send-email-iamjoonsoo.kim@lge.com> <20131219170202.0df2d82a2adefa3ab616bdaa@linux-foundation.org> <20131220140153.GC11295@suse.de> <1387608497.3119.17.camel@buesod1.americas.hpqcorp.net>
 <20131223004438.GA19388@lge.com> <20131223021118.GA2487@lge.com> <1388778945.2956.20.camel@buesod1.americas.hpqcorp.net> <20140106001938.GB696@lge.com> <1389010745.14953.5.camel@buesod1.americas.hpqcorp.net> <20140107015701.GB26726@lge.com>
 <1389062214.9937.0.camel@buesod1.americas.hpqcorp.net>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jan 2014, Davidlohr Bueso wrote:

> > If Andrew agree, It would be great to merge 1-7 patches into mainline
> > before your mutex approach. There are some of clean-up patches and, IMO,
> > it makes the code more readable and maintainable, so it is worth to merge
> > separately.
> 
> Fine by me.
> 

It appears like patches 1-7 are still missing from linux-next, would you 
mind posting them in a series with your approach?
