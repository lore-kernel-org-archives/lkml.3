Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392AbaGIS7z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 14:59:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751724AbaGIS7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 14:59:54 -0400
Date: Wed, 9 Jul 2014 12:04:19 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: navin patidar <navin.patidar@gmail.com>
Cc: Larry.Finger@lwfinger.net, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] staging: rtl8188eu: Remove WEXT_PRIV private ioctl
 handlers
Message-ID: <20140709190419.GA14346@kroah.com>
References: <1404234313-21634-1-git-send-email-navin.patidar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404234313-21634-1-git-send-email-navin.patidar@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 10:35:09PM +0530, navin patidar wrote:
> Remove WEXT_PRIV (non-standard) ioctl handlers.
> 
> Signed-off-by: navin patidar <navin.patidar@gmail.com>
> ---
>  drivers/staging/rtl8188eu/os_dep/ioctl_linux.c | 6335 +++---------------------
>  1 file changed, 744 insertions(+), 5591 deletions(-)

This patch fails to apply :(

Can you refresh it, and resend this series?

thanks,

greg k-h
