Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaF0EOc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 00:14:32 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35975 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbaF0EOa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 00:14:30 -0400
Date: Thu, 26 Jun 2014 20:30:32 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Thomas Vegas <thomas@grouk.net>
Cc: Larry.Finger@lwfinger.net, navin.patidar@gmail.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] staging: rtl8188eu: core: Remove unnecessary
 conditionals
Message-ID: <20140627003032.GA2944@kroah.com>
References: <1403434912-21655-1-git-send-email-thomas@grouk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403434912-21655-1-git-send-email-thomas@grouk.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 22, 2014 at 01:01:50PM +0200, Thomas Vegas wrote:
> The variable 'pxmitbuf' is already set to NULL when entering the
> function. We can remove the first conditional. When _rtw_queue_empty()
> returns false, 'pxmitbuf' if not NULL. We can merge the second and
> third conditional.
> 
> Signed-off-by: Thomas Vegas <thomas@grouk.net>
> ---
>  drivers/staging/rtl8188eu/core/rtw_xmit.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)

Due to changes by others in this file, your patches do not apply
anymore, sorry.

greg k-h
