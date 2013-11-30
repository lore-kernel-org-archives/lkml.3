Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752616Ab3K3NFe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Nov 2013 08:05:34 -0500
Received: from mail-qa0-f43.google.com ([209.85.216.43]:32951 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947Ab3K3NFd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Nov 2013 08:05:33 -0500
Date: Sat, 30 Nov 2013 08:05:19 -0500
From: Tejun Heo <tj@kernel.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kay@vrfy.org, linux-kernel@vger.kernel.org, ebiederm@xmission.com,
        bhelgaas@google.com
Subject: Re: [PATCHSET PARTIAL REPOST driver-core-next] sysfs: separate out
 kernfs, take #3
Message-ID: <20131130130519.GA3581@htj.dyndns.org>
References: <20131128060518.GA5291@kroah.com>
 <1385668487-10181-1-git-send-email-tj@kernel.org>
 <20131129222112.GI21755@mtj.dyndns.org>
 <20131130025524.GA26861@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131130025524.GA26861@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 29, 2013 at 06:55:24PM -0800, Greg KH wrote:
> On Fri, Nov 29, 2013 at 05:21:12PM -0500, Tejun Heo wrote:
> > On Thu, Nov 28, 2013 at 02:54:13PM -0500, Tejun Heo wrote:
> > > Hello, Greg.
> > > 
> > > For some reason, quilt can rebase the patches automatically here.  I'm
> > > reposting the rest of the series (patches 07-41) here just in case.
> > > git branches for both pending patchsets are updated accordingly.
> > > 
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-separate-out-kernfs
> > >  git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git review-kernfs-xattr
> > 
> > Two patches updated - 0032 updated to v3 and 0033 updated to v2.  Both
> > add explicit noop implementation of inline functions for !CONFIG_SYSFS
> > cases.  git branches are updated.  If it's too confusing, pleaes let
> > me know.  I'll repost the whole series.
> 
> No, I think I got it all right, I've applied the series to my tree, care
> to check that I didn't mess anything up?

Looks good to me.  Thanks!

-- 
tejun
