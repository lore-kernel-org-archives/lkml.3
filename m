Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935146AbaE2OTG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 10:19:06 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38695 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933196AbaE2OSZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 10:18:25 -0400
Date: Thu, 29 May 2014 07:18:23 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 000/140] 3.14.5-stable review
Message-ID: <20140529141823.GA28074@kroah.com>
References: <20140529043049.661315084@linuxfoundation.org>
 <20140529155923.61a11b69@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140529155923.61a11b69@notabene.brown>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 29, 2014 at 03:59:23PM +1000, NeilBrown wrote:
> On Wed, 28 May 2014 21:32:19 -0700 Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> 
> > This is the start of the stable review cycle for the 3.14.5 release.
> > There are 140 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat May 31 04:30:12 UTC 2014.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.5-rc1.gz
> > and the diffstat can be found below.
> > 
> 
> Hi Greg,
> I notice that the patch in commit cc13b1d1500656a2 (see below for comment) is
> missing. I was hoping it would be in 3.14.5.  Is there a reason I missed out?

227 patches marked for stable inclusion "missed out" as I just didn't
get to them yet.  So don't worry, you are in good company, I'll get to
them eventually, but 140 patches seemed like a good cut off for this
release.

thanks,

greg k-h
