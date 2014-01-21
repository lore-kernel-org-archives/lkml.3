Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753891AbaAUVSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:18:30 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:46432 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824AbaAUVS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:18:28 -0500
Date: Tue, 21 Jan 2014 13:18:23 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rob Schroer <sulamiification@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drivers/hid/wacom: fixed coding style issues
Message-ID: <20140121211823.GD29615@core.coreip.homeip.net>
References: <20140121195153.GA4198@fedora.fritz.box>
 <20140121200645.GC29615@core.coreip.homeip.net>
 <20140121202944.GA4554@fedora.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140121202944.GA4554@fedora.fritz.box>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 09:29:44PM +0100, Rob Schroer wrote:
> On Tue, Jan 21, 2014 at 12:06:45PM -0800, Dmitry Torokhov wrote:
> > On Tue, Jan 21, 2014 at 08:51:53PM +0100, Robin Schroer wrote:
> > > Fixed some coding style issues regarding spaces before semicolons and
> > > closing parenthesis.
> > > 
> > > Signed-off-by: Robin Schroer <sulamiification@gmail.com>
> > > ---
> > >  drivers/hid/hid-wacom.c | 8 ++++----
> > >  1 file changed, 4 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/hid/hid-wacom.c b/drivers/hid/hid-wacom.c
> > > index 60c75dc..ebcca0d 100644
> > > --- a/drivers/hid/hid-wacom.c
> > > +++ b/drivers/hid/hid-wacom.c
> > > @@ -77,8 +77,8 @@ static void wacom_scramble(__u8 *image)
> > >  	__u16 mask;
> > >  	__u16 s1;
> > >  	__u16 s2;
> > > -	__u16 r1 ;
> > > -	__u16 r2 ;
> > > +	__u16 r1;
> > > +	__u16 r2;
> > >  	__u16 r;
> > >  	__u8 buf[256];
> > >  	int i, w, x, y, z;
> > > @@ -336,7 +336,7 @@ static void wacom_set_features(struct hid_device *hdev, u8 speed)
> > >  
> > >  	switch (hdev->product) {
> > >  	case USB_DEVICE_ID_WACOM_GRAPHIRE_BLUETOOTH:
> > > -		rep_data[0] = 0x03 ; rep_data[1] = 0x00;
> > > +		rep_data[0] = 0x03; rep_data[1] = 0x00;
> > >  		limit = 3;
> > >  		do {
> > >  			ret = hdev->hid_output_raw_report(hdev, rep_data, 2,
> > > @@ -404,7 +404,7 @@ static ssize_t wacom_store_speed(struct device *dev,
> > >  	struct hid_device *hdev = container_of(dev, struct hid_device, dev);
> > >  	int new_speed;
> > >  
> > > -	if (sscanf(buf, "%1d", &new_speed ) != 1)
> > > +	if (sscanf(buf, "%1d", &new_speed) != 1)
> > >  		return -EINVAL;
> > 
> > Why doesn't it use kstrtoXXX()?
> > 
> > Thanks.
> > 
> 
> As far as I can see, kstrtoXXX() might be an alternative, but I was just
> fixing coding style issues, no need to break anything IMO.

You could do the breaking in a follow up patch ;)

Thanks.

-- 
Dmitry
