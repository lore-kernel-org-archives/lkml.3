Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756137AbaJYB5x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2014 21:57:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:37015 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755858AbaJYB5w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2014 21:57:52 -0400
Date: Sat, 25 Oct 2014 09:55:33 +0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>
Subject: Re: [GIT PULL] USB fixes for v3.18-rc2
Message-ID: <20141025015533.GA21572@kroah.com>
References: <1414163652-27364-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414163652-27364-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 10:14:12AM -0500, Felipe Balbi wrote:
> Hi Greg,
> 
> Here's our first set of fixes for v3.18-rc cycle.
> 
> Quite a few goodies here but the most important is that most gadget drivers
> (except for g_hid, g_midi and g_webcam) pass USB[23]0CV with MUSB and DWC3.
> 
> All patches have been tested for weeks (since v3.18 merge window opened) and
> they have also been tested for a few days on top of v3.18-rc1.
> 
> Let me know if you want anything to be changed.
> 
> cheers
> 
> 
> The following changes since commit f114040e3ea6e07372334ade75d1ee0775c355e1:
> 
>   Linux 3.18-rc1 (2014-10-19 18:08:38 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/balbi/usb.git tags/fixes-for-v3.18-rc2

Pulled and pushed out, thanks.

greg k-h
