Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3KOXCB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 18:02:01 -0500
Received: from mail-yh0-f49.google.com ([209.85.213.49]:34086 "EHLO
	mail-yh0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837Ab3KOXBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 18:01:52 -0500
Date: Fri, 15 Nov 2013 15:01:46 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Borislav Petkov <bp@alien8.de>, Andrew Morton <akpm@linux-foundation.org>,
        linux-mm@kvack.org, Mel Gorman <mgorman@suse.de>,
        Hugh Dickins <hughd@google.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, Hillf Danton <dhillf@gmail.com>,
        Michal Hocko <mhocko@suse.cz>, Rik van Riel <riel@redhat.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Wanpeng Li <liwanp@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH] mm/migrate.c: take returned value ofisolate_huge_page()(Re:
 [PATCH 4/9] migrate: add hugepage migration code tomove_pages())
In-Reply-To: <1384527836-981jfadg-mutt-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.DEB.2.02.1311151501290.13382@chino.kir.corp.google.com>
References: <1376025702-14818-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1376025702-14818-5-git-send-email-n-horiguchi@ah.jp.nec.com> <20130928172602.GA6191@pd.tnic> <1380553263-lqp3ggll-mutt-n-horiguchi@ah.jp.nec.com> <20130930160450.GA20030@pd.tnic>
 <1380557324-v44mpchd-mutt-n-horiguchi@ah.jp.nec.com> <20131112115633.GA16700@pd.tnic> <1384444050-v86q6ypr-mutt-n-horiguchi@ah.jp.nec.com> <alpine.DEB.2.02.1311141509390.30112@chino.kir.corp.google.com> <1384527836-981jfadg-mutt-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Nov 2013, Naoya Horiguchi wrote:

> From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Date: Fri, 15 Nov 2013 09:00:15 -0500
> Subject: [PATCH] mm/migrate.c: take returned value of isolate_huge_page()
> 
> Introduces a cosmetic substitution of the returned value of isolate_huge_page()
> to suppress a build warning when !CONFIG_HUGETLBFS. No behavioral change.
> 
> Reported-by: Borislav Petkov <bp@alien8.de>
> Tested-by: Borislav Petkov <bp@alien8.de>
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

Acked-by: David Rientjes <rientjes@google.com>
