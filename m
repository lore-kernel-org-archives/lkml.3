Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaDQTKF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 15:10:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751274AbaDQTJy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 15:09:54 -0400
Date: Thu, 17 Apr 2014 15:09:19 -0400
From: Luiz Capitulino <lcapitulino@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mtosatti@redhat.com,
        aarcange@redhat.com, mgorman@suse.de, andi@firstfloor.org,
        davidlohr@hp.com, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com,
        yinghai@kernel.org, riel@redhat.com, n-horiguchi@ah.jp.nec.com,
        kirill@shutemov.name
Subject: Re: [PATCH v3 0/5] hugetlb: add support gigantic page allocation at
 runtime
Message-ID: <20140417150919.6d59e360@redhat.com>
In-Reply-To: <20140417115242.1081267213b26d10a41d2266@linux-foundation.org>
References: <1397152725-20990-1-git-send-email-lcapitulino@redhat.com>
	<20140417111305.485fa956@redhat.com>
	<20140417115242.1081267213b26d10a41d2266@linux-foundation.org>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Apr 2014 11:52:42 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> On Thu, 17 Apr 2014 11:13:05 -0400 Luiz Capitulino <lcapitulino@redhat.com> wrote:
> 
> > On Thu, 10 Apr 2014 13:58:40 -0400
> > Luiz Capitulino <lcapitulino@redhat.com> wrote:
> > 
> > > [Full introduction right after the changelog]
> > > 
> > > Changelog
> > > ---------
> > > 
> > > v3
> > > 
> > > - Dropped unnecessary WARN_ON() call [Kirill]
> > > - Always check if the pfn range lies within a zone [Yasuaki]
> > > - Renamed some function arguments for consistency
> > 
> > Andrew, this series got four ACKs but it seems that you haven't picked
> > it yet. Is there anything missing to be addressed?
> 
> I don't look at new features until after -rc1.  Then it takes a week or
> more to work through the backlog.  We'll get there.

I see, just wanted to make sure it was in your radar. Thanks a lot.
