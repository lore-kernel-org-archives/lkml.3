Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753018AbaKKJ7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 04:59:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:36015 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751848AbaKKJ7J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 04:59:09 -0500
Date: Tue, 11 Nov 2014 10:59:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Joerg Roedel <joro@8bytes.org>,
        Mel Gorman <mgorman@suse.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        Larry Woodman <lwoodman@redhat.com>, Rik van Riel <riel@redhat.com>,
        Dave Airlie <airlied@redhat.com>, Brendan Conoboy <blc@redhat.com>,
        Joe Donohue <jdonohue@redhat.com>, Duncan Poole <dpoole@nvidia.com>,
        Sherry Cheung <SCheung@nvidia.com>, Subhash Gutti <sgutti@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Mark Hairgrove <mhairgrove@nvidia.com>,
        Lucien Dunning <ldunning@nvidia.com>,
        Cameron Buschardt <cabuschardt@nvidia.com>,
        Arvind Gopalakrishnan <arvindg@nvidia.com>,
        Shachar Raindel <raindel@mellanox.com>,
        Liran Liss <liranl@mellanox.com>,
        Roland Dreier <roland@purestorage.com>,
        Ben Sander <ben.sander@amd.com>, Greg Stoner <Greg.Stoner@amd.com>,
        John Bridgman <John.Bridgman@amd.com>,
        Michael Mantor <Michael.Mantor@amd.com>,
        Paul Blinzer <Paul.Blinzer@amd.com>,
        Laurent Morichetti <Laurent.Morichetti@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Oded Gabbay <Oded.Gabbay@amd.com>,
        =?iso-8859-1?B?Suly9G1l?= Glisse <jglisse@redhat.com>
Subject: Re: [PATCH 3/5] lib: lockless generic and arch independent page
 table (gpt) v2.
Message-ID: <20141111095903.GH10501@worktop.programming.kicks-ass.net>
References: <1415644096-3513-1-git-send-email-j.glisse@gmail.com>
 <1415644096-3513-4-git-send-email-j.glisse@gmail.com>
 <CA+55aFwHd4QYopHvd=H6hxoQeqDV3HT6=436LGU-FRb5A0p7Vg@mail.gmail.com>
 <20141110205814.GA4186@gmail.com>
 <CA+55aFwwKV_D5oWT6a97a70G7OnvsPD_j9LsuR+_e4MEdCOO9A@mail.gmail.com>
 <20141110225036.GB4186@gmail.com>
 <CA+55aFyfgj5ntoXEJeTZyGdOZ9_A_TK0fwt1px_FUhemXGgr0Q@mail.gmail.com>
 <20141111024531.GA2503@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141111024531.GA2503@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 10, 2014 at 09:45:33PM -0500, Jerome Glisse wrote:
> All the complexity arise from two things, first the need to keep ad-hoc
> link btw directory level to facilitate iteration over range.

btw means "by the way" not "between", use a dictionary some time.
