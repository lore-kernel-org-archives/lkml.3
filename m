Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331AbaGAFA3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 01:00:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47407 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750901AbaGAFA1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 01:00:27 -0400
Date: Mon, 30 Jun 2014 21:59:57 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.16-rc4
Message-ID: <20140701045957.GA17105@kroah.com>
References: <1404153635-10868-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404153635-10868-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 30, 2014 at 01:40:35PM -0500, Felipe Balbi wrote:
> Hi Greg,
> 
> Here's my second set of fixes. Note the revert of the patch Michal
> asked to revert.
> 
> Please consider merging to your usb-linus branch. Let me know if you
> want any changes to this pull request.
> 
> cheers
> 
> 
> The following changes since commit 5d881802c407d83c169c875dad88fe2bba066c33:
> 
>   usb: musb: core: Handle Babble condition only in HOST mode (2014-06-19 15:43:07 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.16-rc4

Pulled and pushed out, thanks.

greg k-h
