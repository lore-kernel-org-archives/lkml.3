Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935340Ab3DHJq1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 05:46:27 -0400
Received: from mga14.intel.com ([143.182.124.37]:3159 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935324Ab3DHJq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 05:46:26 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,429,1363158000"; 
   d="scan'208";a="224431648"
Date: Mon, 8 Apr 2013 11:46:21 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: cbouatmailru@gmail.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] AB8500 Power and MFD related updates
Message-ID: <20130408094621.GN24058@zurbaran>
References: <20130307043859.GA11944@gmail.com>
 <20130408091851.GI24058@zurbaran>
 <20130408093303.GF3084@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130408093303.GF3084@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 08, 2013 at 10:33:03AM +0100, Lee Jones wrote:
> > > The following changes since commit 6dbe51c251a327e012439c4772097a13df43c5b8:
> > > 
> > >   Linux 3.9-rc1 (2013-03-03 15:11:05 -0800)
> > > 
> > > are available in the git repository at:
> > > 
> > >   git://git.linaro.org/people/ljones/linux-3.0-ux500.git for-mfd-and-power
> > I was expecting to get an MFD only branch (Basically what your for-mfd branch
> > looks like, and then the for-mfd-and-power one to be based on the mfd only
> > with the power patches applied on top of it.
> > Now, I have to pull the power patches as well, which is no big deal but not
> > ideal neither.
> 
> Sorry Sam, I guess I understood you differently:
> 
> "I can Ack the MFD parts, they look good to me. And then you can take
> the whole thing through your tree, but I'd prefer you to do so by
> pulling the branch Lee prepared for us. I want to avoid conflicts this
> way."
I realize this was not very clear from me, sorry.
I meant I'm fine with Anton taking the whole thing, but by pulling from what
is your current for-mfd-and-power branch. Anton did that and that's all good.
Now, to prevent being flamed to death by Linus, I need to carry the MFD
patches from this branch as well, and that should have come from a common
for-mfd branch.
Basically, what I had in mind:

- You create a for-mfd branch with all the MFD patches need for the
  power patches to be applied properly.
- You create a for-mfd-and-power branch, where you first merge your for-mfd
  branch and then apply the power patches.
- Anton pulls from for-mfd-and-power.
- I pull from for-mfd.
- Anton and me carry the exact same set of MFD patches and regardless of who
  Linus pulls from first, it should work fine.

That should still work from your for-mfd-and-power branch, just slightly
less clean imo, as I will carry power patches I really don't need.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
