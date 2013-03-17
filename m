Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3CQXji (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Mar 2013 19:39:38 -0400
Received: from mga14.intel.com ([143.182.124.37]:47212 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755851Ab3CQXjh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Mar 2013 19:39:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,861,1355126400"; 
   d="scan'208";a="272089081"
Date: Mon, 18 Mar 2013 00:39:07 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: New MFD tree for linux-next
Message-ID: <20130317233907.GB4809@zurbaran>
References: <20130314000201.GA4425@zurbaran>
 <20130315164625.GA29531@zurbaran>
 <20130316132753.591db4c078d06db297ba46a8@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130316132753.591db4c078d06db297ba46a8@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Sat, Mar 16, 2013 at 01:27:53PM +1100, Stephen Rothwell wrote:
> Hi Samuel,
> 
> On Fri, 15 Mar 2013 17:46:25 +0100 Samuel Ortiz <sameo@linux.intel.com> wrote:
> >
> > On Thu, Mar 14, 2013 at 01:02:01AM +0100, Samuel Ortiz wrote:
> > > 
> > > I am moving the MFD development from mfd-2.6.git/for-next to a new mfd-next
> > > tree:
> > > 
> > > git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-next.git
> > > 
> > > Could you please point linux-next at it ? Many thanks in advance.
> 
> Done.  
Thanks.

> I assume that you are still using the for-next branch?
I will update for-next branch to be in sync with mfd-next until the 3.10 merge
window closes. After that I'll probably delete the mfd-2.6.git tree.


> > I'm also carrying MFD fixes through the mfd-fixes tree:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-fixes.git
> > 
> > Could you please also add it to linux-next ?
> 
> What branch should I use of that?
Ah, I didn't see that the remote tree still carries the mfd-2.6 branches, I'll
remove them.
Please use master.


> BTW, those two trees look very similar (in fact "diff -u <(git ls-remote
> mfd) <(git ls-remote mfd-fixes)" only shows a couple of differences in
> all the refs).  You do realise that I can use 2 different branches of one
> tree, right (as can others)?
I understand that :) But using 2 trees rather than 2 separate branches is more
convenient to my personal workflow.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
