Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab3EURJy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 13:09:54 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56751 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab3EURJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 13:09:53 -0400
Date: Tue, 21 May 2013 10:09:52 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] uio/uio_pci_generic: Use module_pci_driver to
 register driver
Message-ID: <20130521170952.GA6895@kroah.com>
References: <1369082865-8885-1-git-send-email-peterhuewe@gmx.de>
 <1369082865-8885-5-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1369082865-8885-5-git-send-email-peterhuewe@gmx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 20, 2013 at 10:47:45PM +0200, Peter Huewe wrote:
> Removing some boilerplate by using module_pci_driver instead of calling
> register and unregister in the otherwise empty init/exit functions.
> 
> It removes a pr_info showing some details about the driver, but
> these infos can also be retrieved by using modinfo.
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
>  drivers/uio/uio_pci_generic.c | 15 +--------------
>  1 file changed, 1 insertion(+), 14 deletions(-)

Please test build your changes, this one breaks the build :(

