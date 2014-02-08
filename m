Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035AbaBHSPy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Feb 2014 13:15:54 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40660 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaBHSPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Feb 2014 13:15:53 -0500
Date: Sat, 8 Feb 2014 10:17:46 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCHSET v2 driver-core-next] kernfs: prepare for cgroup's
 kernfs conversion
Message-ID: <20140208181746.GB10445@kroah.com>
References: <1391454557-32376-1-git-send-email-tj@kernel.org>
 <20140207184320.GD12815@htj.dyndns.org>
 <20140208001254.GA31648@kroah.com>
 <20140208150751.GA3263@htj.dyndns.org>
 <20140208150856.GB3263@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140208150856.GB3263@htj.dyndns.org>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 08, 2014 at 10:08:56AM -0500, Tejun Heo wrote:
> On Sat, Feb 08, 2014 at 10:07:51AM -0500, Tejun Heo wrote:
> > On Fri, Feb 07, 2014 at 04:12:54PM -0800, Greg KH wrote:
> > > Ok, I should have now applied all of these, and hopefully in the correct
> > > order.  If I got anything wrong, please let me know.
> > 
> > Everything looks good to me.
> 
> Ooh, JFYI, I'm pulling driver-core-next into cgroup for-3.15 so that
> cgroup kernfs conversion can be put on top of it.

That's fine with me.  Do you feel kernfs is good enough now for other
subsystems to use?  I want to port debugfs to it when ready.

thanks,

greg k-h
