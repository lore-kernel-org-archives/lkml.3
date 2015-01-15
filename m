Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753597AbbAOAfQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jan 2015 19:35:16 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbbAOAfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jan 2015 19:35:14 -0500
Date: Wed, 14 Jan 2015 16:35:13 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Dirk Hohndel <dirk@hohndel.org>, Nick Dyer <nick.dyer@itdev.co.uk>,
        Benson Leung <bleung@chromium.org>, Yufeng Shen <miletus@chromium.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 3.18 126/150] Revert "Input: atmel_mxt_ts - use deep
 sleep mode when stopped"
Message-ID: <20150115003513.GC14212@kroah.com>
References: <20150114072055.842408181@linuxfoundation.org>
 <20150114072101.550487263@linuxfoundation.org>
 <20150114230002.GA9134@dtor-ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150114230002.GA9134@dtor-ws>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 14, 2015 at 03:00:02PM -0800, Dmitry Torokhov wrote:
> Hi Greg,
> 
> On Tue, Jan 13, 2015 at 11:23:17PM -0800, Greg Kroah-Hartman wrote:
> > 3.18-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Linus Torvalds <torvalds@linux-foundation.org>
> > 
> > commit 7f4054836d811c650c51f9c93088f8ebd61b0020 upstream.
> > 
> > This reverts commit 9d469d033d135d80742a4e39e6bbb4519dd5eee1.
> > 
> > It breaks the Chromebook Pixel touchpad (and touchscreen).
> > 
> > Reported-by: Dirk Hohndel <dirk@hohndel.org>
> > Bisected-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Nick Dyer <nick.dyer@itdev.co.uk>
> > Cc: Benson Leung <bleung@chromium.org>
> > Cc: Yufeng Shen <miletus@chromium.org>
> > Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> > Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> I'd rather we did not apply this to stable just yet - the patch does not
> fix Dirk's Pixel and Linus's still flaky and I have another patch I'm
> waiting on them to try out.

Thanks for letting me know, it's now dropped.

greg k-h
