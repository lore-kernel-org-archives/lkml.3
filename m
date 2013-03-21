Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab3CUVqn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 17:46:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab3CUVql (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 17:46:41 -0400
Date: Thu, 21 Mar 2013 14:46:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Ashish Jangam <ashish.jangam@kpitcummins.com>,
        linux-kernel@vger.kernel.org, dchen@diasemi.com,
        rtc-linux@googlegroups.com, stable@vger.kernel.org
Subject: Re: [patch v1]rtc: fix for DA9052/53 rtc device registration
Message-Id: <20130321144639.a07855c250696903456f3bbb@linux-foundation.org>
In-Reply-To: <20130321152557.GA31935@kroah.com>
References: <1363849747.31938.6.camel@dhruva>
	<20130321152557.GA31935@kroah.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Mar 2013 08:25:57 -0700 Greg KH <gregkh@linuxfoundation.org> wrote:

> On Thu, Mar 21, 2013 at 12:39:07PM +0530, Ashish Jangam wrote:
> > This patch adds supports for the virtual irq since now MFD only handles virtual irq
> > Without this patch rtc device will fail in registration.
> > 
> > This patch is for Linux stable version 3.8.x 
> > 
> > Signed-off-by: Ashish Jangam <ashish.jangam@kpitcummins.com>
> > ---
> >  drivers/rtc/rtc-da9052.c |    8 ++++----
> >  1 files changed, 4 insertions(+), 4 deletions(-)
> 
> <formletter>
> 
> This is not the correct way to submit patches for inclusion in the
> stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
> for how to do this properly.
> 
> </formletter>

This patch is the -stable counterpart of
http://ozlabs.org/~akpm/mmots/broken-out/drivers-rtc-rtc-da9052c-fix-for-rtc-device-registration.patch,
which I'll be sending Linuswards tomorrow, I expect.

So you'll be looking for this patch pretty soon!
