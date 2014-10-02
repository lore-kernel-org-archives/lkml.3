Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565AbaJBBXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 21:23:46 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46027 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752009AbaJBBXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 21:23:45 -0400
Date: Wed, 1 Oct 2014 18:22:47 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jerry Stralko <gerb.stralko@gmail.com>
Cc: gulsah.1004@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] stagging : rtl8821ae : Fixed sparse warning
Message-ID: <20141002012247.GC18380@kroah.com>
References: <5421FDBE.1080706@gmail.com>
 <542C990C.1040702@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542C990C.1040702@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 01, 2014 at 08:15:08PM -0400, Jerry Stralko wrote:
> On 09/23/2014 07:09 PM, Jerry Stralko wrote:
> > Symbol was not declared. Should it be static?
> >
> > Signed-off-by: Jerry Stralko 
> > ---
> >  drivers/staging/rtl8821ae/base.c | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/staging/rtl8821ae/base.c b/drivers/staging/rtl8821ae/base.c
> > index 4a36da0..dea3c4b 100644
> > --- a/drivers/staging/rtl8821ae/base.c
> > +++ b/drivers/staging/rtl8821ae/base.c
> > @@ -1367,7 +1367,7 @@ u8 *rtl_find_ie(u8 *data, unsigned int len, u8 ie)
> >  
> >  /* when we use 2 rx ants we send IEEE80211_SMPS_OFF */
> >  /* when we use 1 rx ant we send IEEE80211_SMPS_STATIC */
> > -struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
> > +static struct sk_buff *rtl_make_smps_action(struct ieee80211_hw *hw,
> >  				     enum ieee80211_smps_mode smps,
> >  				     u8 *da, u8 *bssid)
> >  {
> > @@ -1540,7 +1540,7 @@ static bool rtl_chk_vendor_ouisub(struct ieee80211_hw *hw,
> >  	return matched;
> >  }
> >  
> > -bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
> > +static bool rtl_find_221_ie(struct ieee80211_hw *hw, u8 *data,
> >  		unsigned int len)
> >  {
> >  	struct ieee80211_mgmt *mgmt = (void *)data;
> 
> Ping?

This fell out of my scripts due to the misspelled subject line, sorry.
I'll queue it up when I get a chance to go through the rest of the
"staging" patches, after 3.18-rc1 is out.

thanks,

greg k-h
