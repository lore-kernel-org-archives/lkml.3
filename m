Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619AbaH1PWt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 11:22:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57399 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750812AbaH1PWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 11:22:48 -0400
Date: Thu, 28 Aug 2014 08:22:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Matt <jackdachef@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        ReiserFS Mailing List <reiserfs-devel@vger.kernel.org>
Subject: Re: linux-3.16.2 queue (3.16.1+)
Message-ID: <20140828152205.GA18432@kroah.com>
References: <CAG-aW06Q9VVyW-atZEsURs0rfjysdEbxb_dC4Tm3K-tZg++tQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG-aW06Q9VVyW-atZEsURs0rfjysdEbxb_dC4Tm3K-tZg++tQg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 28, 2014 at 05:16:58PM +0200, Matt wrote:
> Hi Greg,
> 
> 
> please consider adding the following 2 patches to 3.16.2:
> 
> Jan Kara (1):
>       reiserfs: Fix use after free in journal teardown
> 
> Jeff Mahoney (1):
>       reiserfs: fix corruption introduced by balance_leaf refactor
> 
> 
> 
> Reason/Related:
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=83121
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=83321
> 
> http://forums.gentoo.org/viewtopic-t-998538-postdays-0-postorder-asc-start-0.html
> 
> 
> Many thanks in advance

I need git commit ids of these patches in Linus's tree, can you provide
those please?

thanks,

greg k-h
