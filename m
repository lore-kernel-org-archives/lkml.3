Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752165AbaAPAr5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 19:47:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39599 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214AbaAPArz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 19:47:55 -0500
Date: Wed, 15 Jan 2014 19:46:58 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, Matt Mackall <mpm@selenic.com>,
        Cliff Wickman <cpw@sgi.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Pavel Emelyanov <xemul@parallels.com>, Rik van Riel <riel@redhat.com>,
        kirill.shutemov@linux.intel.com, linux-kernel@vger.kernel.org
Message-ID: <1389833218-jf8gq9bo-mutt-n-horiguchi@ah.jp.nec.com>
In-Reply-To: <20140115163230.fdf99574f0e1b0cf97d5cf07@linux-foundation.org>
References: <1389632051-25159-1-git-send-email-n-horiguchi@ah.jp.nec.com>
 <20140115163230.fdf99574f0e1b0cf97d5cf07@linux-foundation.org>
Subject: Re: [PATCH 00/11 v4] update page table walker
Mime-Version: 1.0
Content-Type: text/plain;
 charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
X-Mutt-References: <20140115163230.fdf99574f0e1b0cf97d5cf07@linux-foundation.org>
X-Mutt-Fcc: ~/Maildir/sent/
User-Agent: Mutt 1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 15, 2014 at 04:32:30PM -0800, Andrew Morton wrote:
> On Mon, 13 Jan 2014 11:54:00 -0500 Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:
> 
> > This is ver.4 of page table walker patchset.
> > I rebased it onto mmotm-2014-01-09-16-23, refactored, and commented more.
> > Changes since ver.3 are only on 1/11 and 2/11.
> 
> Looks good to me.

Thanks for the review.

> Patch [1/11] breaks the build ("mm/pagewalk.c:201: error: 'hmask'
> undeclared") and [10/11] fixes that up.
> 
> Please resend everything after 3.14-rc1?

Sure, I'll do with fixing the build warning.

Thanks,
Naoya
