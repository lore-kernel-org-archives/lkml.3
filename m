Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752991Ab3IJWrI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 18:47:08 -0400
Received: from one.firstfloor.org ([193.170.194.197]:47852 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751561Ab3IJWrH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 18:47:07 -0400
Date: Wed, 11 Sep 2013 00:47:04 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Mel Gorman <mgorman@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH 5/9] mbind: add hugepage migration code to mbind()
Message-ID: <20130910224704.GD18242@two.firstfloor.org>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1376025702-14818-6-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130910144109.GR22421@suse.de>
 <1378850009-y4wd5ph0-mutt-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1378850009-y4wd5ph0-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > It makes me wonder how actually useful generic hugetlbfs page migration
> > will be in practice. Are there really usecases where the system
> > administrator is willing to create unused hugepage pools on each node
> > just to enable migration?
> 
> Maybe most users don't want it.

I'm sure some power users will be willing to do that.
Of course for a lot of others THP is enough.

-Andi
