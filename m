Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754241AbaDRUCM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Apr 2014 16:02:12 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:56464 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbaDRUCI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Apr 2014 16:02:08 -0400
Date: Fri, 18 Apr 2014 13:01:01 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Weijie Yang <weijie.yang.kh@gmail.com>
cc: Hugh Dickins <hughd@google.com>, Andrew Morton <akpm@linux-foundation.org>,
        Weijie Yang <weijie.yang@samsung.com>,
        Minchan Kim <minchan@kernel.org>, shli@kernel.org,
        Bob Liu <bob.liu@oracle.com>, Seth Jennings <sjennings@variantweb.net>,
        Heesub Shin <heesub.shin@samsung.com>, Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/8] mm/swap: prevent concurrent swapon on the same
 S_ISBLK blockdev
In-Reply-To: <CAL1ERfO2u838hnY2NVKVd7Tr_=2o=nVpBf_hTKGHms+QFGTFPQ@mail.gmail.com>
Message-ID: <alpine.LSU.2.11.1404181253200.13251@eggly.anvils>
References: <000c01cf1b47$ce280170$6a780450$%yang@samsung.com> <20140203153628.5e186b0e4e81400773faa7ac@linux-foundation.org> <alpine.LSU.2.11.1402032014140.29889@eggly.anvils> <CAL1ERfO2u838hnY2NVKVd7Tr_=2o=nVpBf_hTKGHms+QFGTFPQ@mail.gmail.com>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Apr 2014, Weijie Yang wrote:
> On Tue, Feb 4, 2014 at 12:20 PM, Hugh Dickins <hughd@google.com> wrote:
> >>
> >> Truly, I am fed up with silly swapon/swapoff races.  How often does
> >> anyone call these things?  Let's slap a huge lock around the whole
> >> thing and be done with it?
> >
> > That answer makes me sad: we can't be bothered to get it right,
> > even when Weijie goes to the trouble of presenting a series to do so.
> > But I sure don't deserve a vote until I've actually looked through it.
> 
> Hi,
> 
> This is a ping email. Could I get some options about these patch series?

Sorry, this is no more than a pong in return: I've not lost or
forgotten these, I shall get to them, but priorities intervene.

Hugh
