Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756109Ab3GYNls (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Jul 2013 09:41:48 -0400
Received: from ns.mm-sol.com ([212.124.72.66]:40748 "EHLO extserv.mm-sol.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755417Ab3GYNlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Jul 2013 09:41:44 -0400
Message-ID: <1374759651.1956.29.camel@iivanov-dev.int.mm-sol.com>
Subject: Re: [PATCH 7/7] usb: phy: msm: Lindent the code
From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
To: balbi@ti.com
Cc: linux-arm-msm@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Thu, 25 Jul 2013 16:40:51 +0300
In-Reply-To: <20130724122253.GC17962@radagast>
References: <1372087664-26396-1-git-send-email-iivanov@mm-sol.com>
	 <1372087664-26396-8-git-send-email-iivanov@mm-sol.com>
	 <20130724122253.GC17962@radagast>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi, 

On Wed, 2013-07-24 at 15:22 +0300, Felipe Balbi wrote:
> On Mon, Jun 24, 2013 at 06:27:44PM +0300, Ivan T. Ivanov wrote:
> > From: "Ivan T. Ivanov" <iivanov@mm-sol.com>
> > 
> > Cc: Felipe Balbi <balbi@ti.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: linux-usb@vger.kernel.org
> > Cc: linux-kernel@vger.kernel.org
> > 
> > Signed-off-by: Ivan T. Ivanov <iivanov@mm-sol.com>
> 
> I really don't like blind Lindent patches... sometimes it makes things
> even worse.

It is not exactly blindly. I have removed some of the changes in the
platform_driver structure. 

> 
> > ---
> >  drivers/usb/phy/phy-msm-usb.c |   99 ++++++++++++++++++++++-------------------
> >  1 file changed, 52 insertions(+), 47 deletions(-)
> > 
> > diff --git a/drivers/usb/phy/phy-msm-usb.c b/drivers/usb/phy/phy-msm-usb.c
> > index 6d05085..111f454 100644
> > --- a/drivers/usb/phy/phy-msm-usb.c
> > +++ b/drivers/usb/phy/phy-msm-usb.c
> > @@ -64,8 +64,8 @@ static int msm_hsusb_init_vddcx(struct msm_otg *motg, int init)
> >  
> >  	if (init) {
> >  		ret = regulator_set_voltage(motg->vddcx,
> > -				USB_PHY_VDD_DIG_VOL_MIN,
> > -				USB_PHY_VDD_DIG_VOL_MAX);
> > +					    USB_PHY_VDD_DIG_VOL_MIN,
> > +					    USB_PHY_VDD_DIG_VOL_MAX);
> 
> like here, what's the point ?

It makes indentation the same like the majority of the code.
I could drop this patch if you like.

Thanks,
Ivan


> 


