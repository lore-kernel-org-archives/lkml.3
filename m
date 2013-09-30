Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756197Ab3I3QJ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Sep 2013 12:09:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755885Ab3I3QJX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Sep 2013 12:09:23 -0400
Date: Mon, 30 Sep 2013 12:08:44 -0400
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Message-ID: <1380557324-v44mpchd-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20130930160450.GA20030@pd.tnic>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <1376025702-14818-5-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20130928172602.GA6191@pd.tnic>
 <1380553263-lqp3ggll-mutt-n-horiguchi@ah.jp.nec.com>
 <20130930160450.GA20030@pd.tnic>
Subject: Re: [PATCH 4/9] migrate: add hugepage migration code to move_pages()
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20130930160450.GA20030@pd.tnic>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 30, 2013 at 06:04:50PM +0200, Borislav Petkov wrote:
> On Mon, Sep 30, 2013 at 11:01:03AM -0400, Naoya Horiguchi wrote:
> > Thanks for reporting. The patch should fix this.
> > 
> > Naoya Horiguchi
> > ---
> > From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> > Date: Mon, 30 Sep 2013 10:22:26 -0400
> > Subject: [PATCH] mm/migrate.c: take returned value of isolate_huge_page()
> > 
> > Introduces a cosmetic substitution of the returned value of isolate_huge_page()
> > to suppress a build warning when !CONFIG_HUGETLBFS. No behavioral change.
> > 
> > Reported-by: Borislav Petkov <bp@alien8.de>
> > Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> Thanks for this. Unfortunately, I cannot trigger it anymore. :\ Maybe it
> is because I pulled latest git and this was triggering only on a older
> repo state, hmmm.
> 
> The patch looks obviously correct though so you could send it up or hold
> on to it until someone else reports it.
> 
> Anyway, sorry for the trouble.

OK, no problem :)

Thanks,
Naoya
