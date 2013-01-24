Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755851Ab3AXV5S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 16:57:18 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:33629 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752278Ab3AXV5K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 16:57:10 -0500
Date: Thu, 24 Jan 2013 13:57:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: XHCI: fix memory leak of URB-private data
Message-ID: <20130124215707.GA30414@kroah.com>
References: <Pine.LNX.4.44L0.1301171031260.1339-100000@iolanthe.rowland.org>
 <5101AD55.2000008@fold.natur.cuni.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5101AD55.2000008@fold.natur.cuni.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 24, 2013 at 10:53:25PM +0100, Martin Mokrejs wrote:
> Hi Sarah and Alan,
>   I just saw 3.7.5 patches announced by Greg but I don't see this path in there.
> And, don't know but maybe this applies to older stable kernels as well?
> Where will this patch posted originally to linux-usb land?
> 
> Ah, is that because the email was actually NOT sent to "stable@"? ;-)

No.  It's because the patch isn't in Linus's tree yet, which is one of
the requirements for a patch to be able to get into the stable kernel
releases.

Please read the kernel file, Documentation/stable_kernel_rules.txt for
more details if you are curious.

Hope this helps,

greg k-h
