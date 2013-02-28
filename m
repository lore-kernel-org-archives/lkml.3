Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932195Ab3B1QYc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 11:24:32 -0500
Received: from mail-pb0-f51.google.com ([209.85.160.51]:45163 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758806Ab3B1QYY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 11:24:24 -0500
Date: Thu, 28 Feb 2013 08:24:20 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>
Cc: Shuah Khan <shuahkhan@gmail.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [ 000/150] 3.8.1-stable review
Message-ID: <20130228162420.GA26013@kroah.com>
References: <20130226235523.930663721@linuxfoundation.org>
 <CAKocOOMvPYgHwZLsW49FNsy=Zi5OG4ow+sNd24XnhvXPXA5Ejw@mail.gmail.com>
 <87vc9cbiff.wl%satoru.takeuchi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87vc9cbiff.wl%satoru.takeuchi@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 28, 2013 at 11:51:32PM +0900, Satoru Takeuchi wrote:
> At Wed, 27 Feb 2013 09:50:03 -0700,
> Shuah Khan wrote:
> > 
> > On Tue, Feb 26, 2013 at 4:54 PM, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > > This is the start of the stable review cycle for the 3.8.1 release.
> > > There are 150 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Thu Feb 28 23:52:34 UTC 2013.
> > > Anything received after that time might be too late.
> 
> Greg, 3.8.1 is already released although now is only "Thu Feb 28 14:45:19 UTC 2013".
> Is there any rule to move up the deadline? I encountered such situation several
> times and didn't understand why it happened.

It happens sometimes due to my travel schedule, and based on how "good"
I think this release is.  3.8.1 had a bunch of fixes in it that people
really needed (myself included, it fixed resume on my main travel
laptop), and I'm staring at a bunch more 3.8-stable patches that need to
get queued up, so I did the release a few hours early.

Hope this helps,

greg k-h
