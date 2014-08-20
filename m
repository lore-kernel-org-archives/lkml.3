Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752342AbaHTLT6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:19:58 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35715 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752318AbaHTLT4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:19:56 -0400
Date: Wed, 20 Aug 2014 06:19:16 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hoang Tran <hoangtran.gwr@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8821ae: fix sparse warning for static
 declarations in rtl8821ae/stats.c
Message-ID: <20140820111916.GA12812@kroah.com>
References: <1408524802-27441-1-git-send-email-hoangtran.gwr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408524802-27441-1-git-send-email-hoangtran.gwr@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 04:53:22PM +0800, Hoang Tran wrote:
> This patch fixes the following sparse warnings in rtl8821ae/stats.c
> 
> drivers/staging/rtl8821ae/stats.c:62:6: warning: symbol 'rtl_translate_todbm' was not declared. Should it be static?
> drivers/staging/rtl8821ae/stats.c:101:6: warning: symbol 'rtl_process_ui_rssi' was not declared. Should it be static?
> 
> Signed-off-by: Hoang Tran <hoangtran.gwr@gmail.com>
> ---
>  drivers/staging/rtl8821ae/stats.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

You sent 2 patches that look to do the same thing, but are different, so
I have no idea which to apply.  Always properly "version" your patches
so as to not confuse easily-confused maintainers.

I've dropped both of these, please resend the one you really want to be
considered.

thanks,

greg k-h
