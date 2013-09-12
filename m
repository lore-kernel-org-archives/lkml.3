Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961Ab3ILPDB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 11:03:01 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48289 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752120Ab3ILPDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 11:03:00 -0400
Date: Thu, 12 Sep 2013 11:02:47 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] firmware: Be a bit more verbose about direct firmware
 loading failure
Message-ID: <20130912150247.GB8619@hmsreliant.think-freely.org>
References: <1378496168-3684-1-git-send-email-nhorman@tuxdriver.com>
 <CACVXFVPRWEXMHyGhfZVGX2HrL3cguqVBUjTS51r2p8EGt=EPdg@mail.gmail.com>
 <20130911141943.GA3181@neilslaptop.think-freely.org>
 <CACVXFVNfkfsSJJUK_BWHLnddk=NAWDJoERmg_qycYa11G_X2RA@mail.gmail.com>
 <20130912131655.GA8619@hmsreliant.think-freely.org>
 <CACVXFVP45r2HHonckK+mbiX9BkpxwQoDAbzy2dwXa_DwJHe=cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVP45r2HHonckK+mbiX9BkpxwQoDAbzy2dwXa_DwJHe=cA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: -2.9 (--)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 12, 2013 at 10:30:59PM +0800, Ming Lei wrote:
> On Thu, Sep 12, 2013 at 9:16 PM, Neil Horman <nhorman@tuxdriver.com> wrote:
> >>
> > Please re-read the patch, then point out to me which printk the above action
> > will trigger, because its not happening in my testing. If you'll take a look at
> > fw_get_filesystem_firmware, you'll see that if the filp_open on a firmware file
> > fails, we continue the for loop through the list of available search paths.  No
> > error is generated in the case you describe above.
> 
> You are right, sorry for missing "if (IS_ERR(file))  continue;",  and looks the
> patch is good.
> 
> Acked-by: Ming Lei <ming.lei@canonical.com>
> 
> Thanks,
Awesome, thanks!
Neil

> --
> Ming Lei
> 
