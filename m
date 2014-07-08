Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591AbaGHV2M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 17:28:12 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40259 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753226AbaGHV2K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 17:28:10 -0400
Date: Tue, 8 Jul 2014 14:26:38 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Ben Hutchings <ben@decadent.org.uk>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>, Christoph Lameter <cl@linux.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.2 099/125] mm: fix crashes from mbind() merging vmas
In-Reply-To: <alpine.LSU.2.11.1407081336180.31914@eggly.anvils>
Message-ID: <alpine.LSU.2.11.1407081420220.31914@eggly.anvils>
References: <lsq.1404846110.431506873@decadent.org.uk> <alpine.LSU.2.11.1407081336180.31914@eggly.anvils>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jul 2014, Hugh Dickins wrote:
> On Tue, 8 Jul 2014, Ben Hutchings wrote:
> 
> > 3.2.61-rc1 review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Hugh Dickins <hughd@google.com>
> > 
> > commit d05f0cdcbe6388723f1900c549b4850360545201 upstream.
> 
> I don't think that's correct, I can't see a change to the
> "vma = check_range(" in migrate_to_node() which 3.2 and 3.4 trees have.
> Does it build (without warning) with CONFIG_NUMA and CONFIG_MIGRATION?
> I expect this version I sent yesterday for 3.4.98 will be good for 3.2:

Hah, I now see that 098/125 in your series removes precisely the "vma = "
I was calling attention to.  So all should be okay and you can ignore me.

Hugh
