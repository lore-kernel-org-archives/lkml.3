Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752446AbaHTLnx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:43:53 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:39233 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751885AbaHTLnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:43:51 -0400
Date: Wed, 20 Aug 2014 19:43:48 +0800
From: Hoang Tran <hoangtran.gwr@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Sachin Kamat <sachin.kamat@linaro.org>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8821ae: fix sparse warning for static
 declarations in rtl8821ae/stats.c
Message-ID: <20140820114348.GA28381@funtoo.greenwavereality.com>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Sachin Kamat <sachin.kamat@linaro.org>, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1408524802-27441-1-git-send-email-hoangtran.gwr@gmail.com>
 <20140820111916.GA12812@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820111916.GA12812@kroah.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Aug 20, 2014 at 06:19am, Greg Kroah-Hartman wrote:
> On Wed, Aug 20, 2014 at 04:53:22PM +0800, Hoang Tran wrote:
> > This patch fixes the following sparse warnings in rtl8821ae/stats.c
> > 
> > drivers/staging/rtl8821ae/stats.c:62:6: warning: symbol 'rtl_translate_todbm' was not declared. Should it be static?
> > drivers/staging/rtl8821ae/stats.c:101:6: warning: symbol 'rtl_process_ui_rssi' was not declared. Should it be static?
> > 
> > Signed-off-by: Hoang Tran <hoangtran.gwr@gmail.com>
> > ---
> >  drivers/staging/rtl8821ae/stats.c | 5 +++--
> >  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> You sent 2 patches that look to do the same thing, but are different, so
> I have no idea which to apply.  Always properly "version" your patches
> so as to not confuse easily-confused maintainers.
> 

Thanks, I resent the patch here https://lkml.org/lkml/2014/8/20/246

> I've dropped both of these, please resend the one you really want to 
> be
> considered.
> 
> thanks,
> 
> greg k-h
