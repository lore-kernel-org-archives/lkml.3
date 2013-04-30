Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933974Ab3D3Xdj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 19:33:39 -0400
Received: from mail-da0-f42.google.com ([209.85.210.42]:35991 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933834Ab3D3Xdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 19:33:36 -0400
Date: Tue, 30 Apr 2013 16:33:34 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Robert Love <rlove@google.com>
Cc: Shankar Brahadeeswaran <shankoo77@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Bjorn Bringert <bringert@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, devel@driverdev.osuosl.org,
        Hugh Dickins <hughd@google.com>, Anjana V Kumar <anjanavk12@gmail.com>
Subject: Re: [BUG] staging: android: ashmem: Deadlock during ashmem_shrink
Message-ID: <20130430233334.GA32383@kroah.com>
References: <CAJsYZ5kk=J_Sc7w5dbMbkWWv8dXEU0ojKjEKNqH=Q6Tf2f7mQg@mail.gmail.com>
 <20130422142218.GA26760@mwanda>
 <CAG6tG3xc3RHD7sZXaEbg1vLRhFj+6d1wY=us4BfxBfi5y0o4zg@mail.gmail.com>
 <CAJsYZ5nQg9g73r5yLicq6gAGbKEXVAFqtF2av=heeNtrNSPSWg@mail.gmail.com>
 <CAG6tG3zcOdkA5QOBhaDzmMvcFSCwbfRAyKuRwXdn6ipOJhTVZQ@mail.gmail.com>
 <CAJsYZ5mpukCM6TpFb27tJt6G7ZufugEP4kx8wzGxhRwAO46cCw@mail.gmail.com>
 <CAG6tG3wrHKTJBOu69XiV6BAPfvmK-QqJkBVpzkmkrLdLV5jRwQ@mail.gmail.com>
 <CAJsYZ5kchksgObAS66T5b-4VPrjp4Mhn4HG0DHyWBgRXib3JTw@mail.gmail.com>
 <CAG6tG3ybiaSRt15s63Dz_33_-jsrrBAamOAV_t7QOW0N_zWueg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG6tG3ybiaSRt15s63Dz_33_-jsrrBAamOAV_t7QOW0N_zWueg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 06:32:54PM -0400, Robert Love wrote:
> > After this experiment, I too think that this patch (returning from
> > ashmem_shrink if the lock is not available) is good enough and does
> > not seem to have any major side effects.
> >
> > PS: Any plans of submitting this patch formally?
> 
> Sure. Greg? :)

I'll be glad to take it if you resend it in a format that I can apply it
in :)

thanks,

greg k-h
