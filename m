Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932994Ab3FRSmJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 14:42:09 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51043 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756197Ab3FRSmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 14:42:08 -0400
Date: Tue, 18 Jun 2013 11:42:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Chad Williamson <chad@dahc.us>
Cc: Lorenz Haspel <lorenz@badgers.com>,
        Michael Banken <michael.banken@mathe.stud.uni-erlangen.de>,
        puff65537@bansheeslibrary.com, viro@zeniv.linux.org.uk,
        tulinizer@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] Staging: silicom: coding style cleanup
Message-ID: <20130618184207.GA20837@kroah.com>
References: <1371526325-9821-1-git-send-email-chad@dahc.us>
 <CAP5fS0Q+1B3L1i2HH0=2p8NRvdhwJGE=U8yjjo2QnZBuaaES3w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAP5fS0Q+1B3L1i2HH0=2p8NRvdhwJGE=U8yjjo2QnZBuaaES3w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 18, 2013 at 09:13:00AM -0500, Chad Williamson wrote:
>     Chad Williamson (4):
>       Staging: silicom: remove unnecessary braces in bpctl_mod.c
>       Staging: silicom: whitespace fixes in bpctl_mod.c
>       Staging: silicom: move assignments out of if conditions
>       Staging: silicom: move more assignments out of if conditions
> 
>      drivers/staging/silicom/bpctl_mod.c | 171
>     ++++++++++++++++++++----------------
>      1 file changed, 94 insertions(+), 77 deletions(-)
> 
>  
> Hmm... It seems this patchset collides with Lorenz Haspel and Michael Banken's
> work already well under review, so feel free to disregard it.

Only the 2nd patch wouldn't apply, so feel free to respin that one.

thanks,

greg k-h
