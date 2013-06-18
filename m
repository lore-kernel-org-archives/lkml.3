Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933619Ab3FRVeZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 17:34:25 -0400
Received: from longford.logfs.org ([213.229.74.203]:59589 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932869Ab3FRVeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 17:34:24 -0400
Date: Tue, 18 Jun 2013 16:04:33 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 0/2] hugetlb fixes
Message-ID: <20130618200433.GA28198@logfs.org>
References: <1371581225-27535-1-git-send-email-joern@logfs.org>
 <20130618185055.GA27618@logfs.org>
 <20130618132705.c5eb78a20499beb1b769f741@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130618132705.c5eb78a20499beb1b769f741@linux-foundation.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 June 2013 13:27:05 -0700, Andrew Morton wrote:
> On Tue, 18 Jun 2013 14:50:55 -0400 J__rn Engel <joern@logfs.org> wrote:
> 
> > On Tue, 18 June 2013 14:47:03 -0400, Joern Engel wrote:
> > > 
> > > Test program below is failing before these two patches and passing
> > > after.
> > 
> > Actually, do we have a place to stuff kernel tests?  And if not,
> > should we have one?
> 
> Yep, tools/testing/selftests/vm.  It's pretty simple and stupid at
> present - it anything about the framework irritates you, please fix it!

Just did. :)

Jörn

--
Maintenance in other professions and of other articles is concerned with
the return of the item to its original state; in Software, maintenance
is concerned with moving an item away from its original state.
-- Les Belady
