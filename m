Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754053Ab3K0LvB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:51:01 -0500
Received: from mail-lb0-f177.google.com ([209.85.217.177]:57841 "EHLO
	mail-lb0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3K0Lu5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:50:57 -0500
Date: Wed, 27 Nov 2013 15:50:52 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: William Dauchy <wdauchy@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Andy Lutomirski <luto@amacapital.net>, Matt Mackall <mpm@selenic.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Peter Zijlstra <peterz@infradead.org>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Mel Gorman <mel@csn.ul.ie>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.11 54/66] mm: migration: do not lose soft dirty bit if
 page is in migration state
Message-ID: <20131127115052.GX29824@moon>
References: <20131101220634.605745564@linuxfoundation.org>
 <20131101220649.696585269@linuxfoundation.org>
 <CAJ75kXa=zh3NBRqR43nRv2s7WToDMNSmARs1PMABOE8-7hksDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ75kXa=zh3NBRqR43nRv2s7WToDMNSmARs1PMABOE8-7hksDw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 12:38:10PM +0100, William Dauchy wrote:
> Hi Greg,
> 
> I was wondering if v3.10.x stable branch was also concerned by this
> patch since I did not found it in this later branch.
> Maybe too hard to backport? (I saw that it requires new functions like
> pte_swp_soft_dirty which is not present in v3.10.x)
> Maybe it was planned in the future?

"Soft dirty bit" feature introduced in 3.11 kernel and as far as I know
we've no plans to backport it on 3.10 series.
