Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754456AbaA1Cgs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 21:36:48 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:11415 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753354AbaA1Cgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 21:36:47 -0500
Message-ID: <1390876601.27421.20.camel@buesod1.americas.hpqcorp.net>
Subject: Re: [PATCH 5/8] mm, hugetlb: use vma_resv_map() map types
From: Davidlohr Bueso <davidlohr@hp.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: akpm@linux-foundation.org, iamjoonsoo.kim@lge.com, riel@redhat.com,
        mgorman@suse.de, mhocko@suse.cz, aneesh.kumar@linux.vnet.ibm.com,
        kamezawa.hiroyu@jp.fujitsu.com, hughd@google.com,
        david@gibson.dropbear.id.au, js1304@gmail.com,
        liwanp@linux.vnet.ibm.com, dhillf@gmail.com, rientjes@google.com,
        aswin@hp.com, scott.norton@hp.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Mon, 27 Jan 2014 18:36:41 -0800
In-Reply-To: <1390856607-psfeyzze-mutt-n-horiguchi@ah.jp.nec.com>
References: <1390794746-16755-1-git-send-email-davidlohr@hp.com>
	 <1390794746-16755-6-git-send-email-davidlohr@hp.com>
	 <1390856607-psfeyzze-mutt-n-horiguchi@ah.jp.nec.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4 (3.6.4-3.fc18) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-01-27 at 16:03 -0500, Naoya Horiguchi wrote:
> On Sun, Jan 26, 2014 at 07:52:23PM -0800, Davidlohr Bueso wrote:
> > From: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > 
> > Util now, we get a resv_map by two ways according to each mapping type.
> > This makes code dirty and unreadable. Unify it.
> > 
> > Reviewed-by: Aneesh Kumar K.V <aneesh.kumar@linux.vnet.ibm.com>
> > Signed-off-by: Joonsoo Kim <iamjoonsoo.kim@lge.com>
> > Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
> 
> Reviewed-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> There are a few small nitpicking below ...

Will update, thanks!

