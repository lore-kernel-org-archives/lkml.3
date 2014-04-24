Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032AbaDXTr6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 15:47:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38900 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911AbaDXTry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 15:47:54 -0400
Date: Thu, 24 Apr 2014 12:50:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Mathias Nyman <mathias.nyman@linux.intel.com>
Cc: linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5] xhci: fixes for 3.15-rc usb-linus
Message-ID: <20140424195047.GF12809@kroah.com>
References: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398169382-12097-1-git-send-email-mathias.nyman@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 03:22:57PM +0300, Mathias Nyman wrote:
> Hi Greg
> 
> Here are the xhci fixes for 3.15-rc usb-linus.
> Most of them are very small fixes that didn't make
> it to 3.14, sitting and waiting for 3.15-rc1 to come out.
> 
> Only the "Prefer endpoint context.." patch  by Julius has a bit more content.
>  
> These patches are picked together with Sarah, they are tested on top of
> 3.15-rc1, and apply on your current usb-linus branch

Please redo all of these based on my comments.

thanks,

greg k-h
