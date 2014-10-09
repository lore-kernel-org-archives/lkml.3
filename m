Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751849AbaJITsg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 15:48:36 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35078 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbaJITsZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 15:48:25 -0400
Date: Thu, 9 Oct 2014 12:48:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Tsung-Han Lin <tsunghan.tw@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8192u: correct coding style errors
Message-ID: <20141009194824.GA13446@kroah.com>
References: <1412874122-7650-1-git-send-email-tsunghan.tw@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1412874122-7650-1-git-send-email-tsunghan.tw@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 10, 2014 at 01:02:02AM +0800, Tsung-Han Lin wrote:
> Correct some coding style errors in
> drivers/staging/rtl8192u/r819xU_firmware.c.
> 
> Signed-off-by: Tsung-Han Lin <tsunghan.tw@gmail.com>
> ---
>  drivers/staging/rtl8192u/r819xU_firmware.c | 65 +++++++++++++++---------------
>  1 file changed, 33 insertions(+), 32 deletions(-)

This doesn't apply due to changes others have made in this file.  Also,
listen to Joe's comments for your next patch.

thanks,

greg k-h
