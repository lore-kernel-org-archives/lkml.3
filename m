Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516AbaK2KlN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Nov 2014 05:41:13 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:50214 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751317AbaK2KlM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Nov 2014 05:41:12 -0500
Date: Sat, 29 Nov 2014 11:41:02 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Andrew Jackson <Andrew.Jackson@arm.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Dave Airlie <airlied@gmail.com>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liviu Dudau <Liviu.Dudau@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] drm: i2c: tda998x: Retry fetching the EDID if it fails
 first time.
Message-ID: <20141129114102.02366857@armhf>
In-Reply-To: <54783A2F.5010405@arm.com>
References: <546B84C6.3090809@arm.com>
	<20141128091905.3e491c39@armhf>
	<54783A2F.5010405@arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Nov 2014 09:02:39 +0000
Andrew Jackson <Andrew.Jackson@arm.com> wrote:

> > It seems that your patch is deprecated by Laurent Pinchart's
> > 	[PATCH] drm: tda998x: Use drm_do_get_edid()
> > http://lists.freedesktop.org/archives/dri-devel/2014-November/072906.html
> >   
> 
> Thank you for the heads-up, I'd not seen that.  I'll consider how my patch might be modified to suit the new infrastructure.

You don't need any patch: drm_do_get_edid() already loops on reading
the EDID.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
