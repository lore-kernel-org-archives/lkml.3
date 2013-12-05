Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab3LEOas (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 09:30:48 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:42372 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab3LEOaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 09:30:46 -0500
Date: Thu, 5 Dec 2013 06:31:53 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Tomas Winkler <tomas.winkler@intel.com>
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: Re: [char-misc-next] mei: add 9 series PCH mei device ids
Message-ID: <20131205143153.GA5151@kroah.com>
References: <1386228884-30978-1-git-send-email-tomas.winkler@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386228884-30978-1-git-send-email-tomas.winkler@intel.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 09:34:44AM +0200, Tomas Winkler wrote:
> And Lynx Point H Refresh and Wildcat Point LP
> device ids.
> 
> Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
> ---
> V2: remove duplicated  LPT entry
> 
>  drivers/misc/mei/hw-me-regs.h | 5 ++++-
>  drivers/misc/mei/pci-me.c     | 4 +++-
>  2 files changed, 7 insertions(+), 2 deletions(-)

This should go into 3.13-final, right?  What about -stable versions?

thanks,

greg k-h
