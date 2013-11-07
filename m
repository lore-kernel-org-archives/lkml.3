Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab3KGDC4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 22:02:56 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:43610 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753150Ab3KGDCx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 22:02:53 -0500
Date: Wed, 6 Nov 2013 19:05:11 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Olav Haugan <ohaugan@codeaurora.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Minchan Kim <minchan@kernel.org>, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH] staging: zsmalloc: Ensure handle is never 0 on success
Message-ID: <20131107030511.GC8482@kroah.com>
References: <1383699252-8898-1-git-send-email-ohaugan@codeaurora.org>
 <20131106015645.GA28769@kroah.com>
 <CAPkvG_eEhArzS2feJ_8y6vKBjtd7bYUNwwWWz-MQHUDXCu_5hg@mail.gmail.com>
 <20131106221012.GA13488@kroah.com>
 <CAPkvG_fgkqeQt3=eqnDM7bWQXdeeybRULiU2MdNh5KF1KoeRFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPkvG_fgkqeQt3=eqnDM7bWQXdeeybRULiU2MdNh5KF1KoeRFw@mail.gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 06, 2013 at 03:46:19PM -0800, Nitin Gupta wrote:
 > I'm getting really tired of them hanging around in here for many years
> > now...
> >
> 
> Minchan has tried many times to promote zram out of staging. This was
> his most recent attempt:
> 
> https://lkml.org/lkml/2013/8/21/54
> 
> There he provided arguments for zram inclusion, how it can help in
> situations where zswap can't and why generalizing /dev/ramX would
> not be a great idea. So, cannot say why it wasn't picked up
> for inclusion at that time.
> 
> > Should I just remove them if no one is working on getting them merged
> > "properly"?
> >
> 
> Please refer the mail thread (link above) and see Minchan's
> justifications for zram.
> If they don't sound convincing enough then please remove zram+zsmalloc
> from staging.

You don't need to be convincing me, you need to be convincing the
maintainers of the area of the kernel you are working with.

And since the last time you all tried to get this merged was back in
August, I'm feeling that you all have given up, so it needs to be
deleted.  I'll go do that for 3.14, and if someone wants to pick it up
and merge it properly, they can easily revert it.

thanks,

greg k-h
