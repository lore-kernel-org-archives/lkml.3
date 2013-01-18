Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab3ARAsc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 19:48:32 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:55540 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754708Ab3ARAsa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 19:48:30 -0500
Date: Thu, 17 Jan 2013 16:48:27 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: linux-kernel@vger.kernel.org,
        Serban Constantinescu <serban.constantinescu@arm.com>,
        Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
        Colin Cross <ccross@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [RFC][PATCH 0/3] staging: alarm-dev: Cleanups and compat_ioctl
 support (v2)
Message-ID: <20130118004827.GB8897@kroah.com>
References: <1357947984-15611-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357947984-15611-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 03:46:21PM -0800, John Stultz wrote:
> Here is the second revision at implementing compat_ioctl support for
> Android's alarm-dev driver in staging.
> 
> The first patch removes the pre-Android 1.0 _OLD ioctls, per Colin's
> suggestion. Then the second patch does some refactoring to cleanup
> and separate the copying of user data from the logic, and the final
> patch adds the compat_ioctl support.
> 
> I've tested this with a trivial unit test compiled for both 32bit
> and 64bit on a x86_64 kernel, and it looks ok, but closer review
> would be appreciated to make sure I didn't break anything.
> 
> Additional feedback or thoughts would be welcome!

These look fine to me, want me to apply them to my -next tree for 3.9?

thanks,

greg k-h
