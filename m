Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbaIKWhq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 18:37:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:44285 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaIKWho (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 18:37:44 -0400
Date: Thu, 11 Sep 2014 15:37:44 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "John W. Linville" <linville@tuxdriver.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: repeated bugs in new rtl wifi drivers
Message-ID: <20140911223744.GA21531@kroah.com>
References: <CAGXu5j+kh3TTR8yiyH35mXUo91g5a-ULS6w2CvKzGmQ4UuL-aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+kh3TTR8yiyH35mXUo91g5a-ULS6w2CvKzGmQ4UuL-aA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 11, 2014 at 03:27:39PM -0700, Kees Cook wrote:
> Hi,
> 
> I keep fixing this same bug that keeps showing up in the rtl wifi
> drivers. CL_PRINTF keeps getting redefined (incorrectly) instead of
> using a correctly fixed global. Is there a way to stop this from
> happening again?
> 
> Here are the past three (identical) fixes I've landed:
> a3355a62673e2c4bd8617d2f07c8edee92a89b8d
> 037526f1ae7eeff5cf27ad790ebfe30303eeebe8
> 6437f51ec36af8ef1e3e2659439b35c37e5498e2
> 
> And the buildbot report below seems to show there are more to be made. :)

Until we figure out a way to keep having the whole rtl wifi driver as a
duplicate of the previous driver before we cleaned it up, I don't know
of a way to do this :(

Larry, I know you keep talking to these developers, any chance anything
is ever going to get better?  Anyone I can talk to?  Even in person, I
go to Taiwan fairly often...

thanks,

greg k-h
