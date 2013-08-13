Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab3HMGUo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:20:44 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:46767 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187Ab3HMGUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:20:43 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Tue, 13 Aug 2013 02:20:42 EDT
X-Sasl-enc: wI15wWVUgNfjyzKjamtTWyHEeRFtHjkcPSWZ/jZxoUPT 1376374842
Date: Mon, 12 Aug 2013 23:22:07 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ming Lei <ming.lei@canonical.com>
Subject: Re: linux-next: manual merge of the usb tree with the net-next tree
Message-ID: <20130813062207.GA23613@kroah.com>
References: <20130813161359.0613bddf9bbf983253333f30@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130813161359.0613bddf9bbf983253333f30@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 04:13:59PM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> Today's linux-next merge of the usb tree got a conflict in
> include/linux/usb/usbnet.h between commit a88c32ae15f2 ("USBNET:
> centralize computing of max rx/tx qlen") from the net-next tree and
> commit 638c5115a794 ("USBNET: support DMA SG") from the usb tree.
> 
> I fixed it up (see below) and can carry the fix as necessary (no action
> is required).

Yeah, I knew that would happen, it was the easiest way to get these
patches in due to the cross-tree dependancies.  The fix looks correct,
thanks.

greg k-h
