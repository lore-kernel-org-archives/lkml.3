Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752074AbaH3U42 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2014 16:56:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53938 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaH3U4R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2014 16:56:17 -0400
Date: Sat, 30 Aug 2014 13:56:16 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Hoang Tran <hoangtran.gwr@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] staging: rtl8821ae: fix sparse warning for static
 declarations in rtl8821ae/stats.c
Message-ID: <20140830205616.GA22433@kroah.com>
References: <1408762551-14919-1-git-send-email-hoangtran.gwr@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408762551-14919-1-git-send-email-hoangtran.gwr@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 23, 2014 at 10:55:51AM +0800, Hoang Tran wrote:
> This patch fixes the following sparse warnings in rtl8821ae/stats.c
> 
> drivers/staging/rtl8821ae/stats.c:62:6: warning: symbol 'rtl_translate_todbm' was not declared. Should it be static?
> drivers/staging/rtl8821ae/stats.c:101:6: warning: symbol 'rtl_process_ui_rssi' was not declared. Should it be static?
> 
> Signed-off-by: Hoang Tran <hoangtran.gwr@gmail.com>
> ---
>  drivers/staging/rtl8821ae/stats.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)

I applied the second patch you sent, why resend it?  What was different
between this one and the previous 2?  Please always be specific about
what you are changing, otherwise I have no idea what to do...

greg k-h
