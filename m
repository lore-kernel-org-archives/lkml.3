Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964889AbaCTVOH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 17:14:07 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760014AbaCTVOE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 17:14:04 -0400
Date: Thu, 20 Mar 2014 14:16:09 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, lgirdwood@gmail.com,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        shuahkhan@gmail.com
Subject: Re: [PATCH 3.13] regulator: core: Change dummy supplies error
 message to a warning
Message-ID: <20140320211609.GB2813@kroah.com>
References: <1394054987-4743-1-git-send-email-shuah.kh@samsung.com>
 <20140319235828.GC22080@kroah.com>
 <20140320100241.GB11706@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140320100241.GB11706@sirena.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 20, 2014 at 10:02:41AM +0000, Mark Brown wrote:
> On Wed, Mar 19, 2014 at 11:58:28PM +0000, Greg KH wrote:
> > On Wed, Mar 05, 2014 at 02:29:47PM -0700, Shuah Khan wrote:
> 
> > > -		dev_err(dev, "dummy supplies not allowed\n");
> > > +		dev_warn(dev, "dummy supplies not allowed\n");
> 
> > This really isn't a problem that warrents a stable backport, sorry.  I
> > can understand distros being "annoyed" at it, but probably not.
> 
> A previous stable commit caused this to happen for esentially every
> regulator request on x86 when previously it wouldn't have triggered.

Ick, ok, fair enough, I'll queue it up, thanks.

greg k-h
