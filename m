Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755040Ab3H1Rf2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 13:35:28 -0400
Received: from mga09.intel.com ([134.134.136.24]:31892 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753520Ab3H1Rf1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 13:35:27 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,976,1367996400"; 
   d="scan'208";a="369866042"
Date: Wed, 28 Aug 2013 10:35:26 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: Kumar Gaurav <kumargauravgupta3@gmail.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>, gregkh@linuxfoundation.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH v3] xHCI: Fixing xhci_readl definition and function call
Message-ID: <20130828173526.GD26483@xanatos>
References: <1377482937-7486-1-git-send-email-kumargauravgupta3@gmail.com>
 <20130828071304.GO6329@mwanda>
 <521E1292.5060709@gmail.com>
 <20130828170137.GB26483@xanatos>
 <521E3044.80109@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <521E3044.80109@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 28, 2013 at 10:45:48PM +0530, Kumar Gaurav wrote:
> On Wednesday 28 August 2013 10:31 PM, Sarah Sharp wrote:
> >On Wed, Aug 28, 2013 at 08:39:06PM +0530, Kumar Gaurav wrote:
> >>On Wednesday 28 August 2013 12:43 PM, Dan Carpenter wrote:
> >>>On Mon, Aug 26, 2013 at 07:38:57AM +0530, Kumar Gaurav wrote:
> >>I've started cloning linux-next and as it's not applying on
> >>linux-next, I'll try it on linux-next (once i cloned it)  and will
> >>send again.
> >Yeah, this doesn't apply against Greg's usb-next tree, so I can't take
> >it.  If you're sending non-bug fixes in, you need to base your patches
> >against that tree, or linux-next.
> >
> >Sarah Sharp
> I'm trying against linux-git as
>     cat
> 0027-xHCI-Fixing-xhci_readl-definition-and-function-call.patch|
> patch

No, don't do that.  Use `git am` instead, possibly with the 3-way merge
options.

> and then after i enter the required file (drivers/usb/host/xhci-dbg.c).
> it's giving me  message
> 
> File to patch: drivers/usb/host/xhci-dbg.c
> patching file drivers/usb/host/xhci-dbg.c
> can't find file to patch at input line 180
> Perhaps you should have used the -p or --strip option?
> The text leading up to this was:
> 
> but when i saw the file i found changes are applied there.
> 
> I had made the patch using git format-patch. what could be the
> possible reason behind this issue or am i mistaking somewhere?

I would try checking out linux-next on a new branch, and then using `git
cherry-pick` to apply your patch.  That will try to apply the patch, and
give you merge conflicts if they don't apply.  You'll need to clean
those conflicts up and re-submit the resulting patch.  You may have to
re-do the patch if you can't get it to apply against linux-next.

Sarah Sharp
