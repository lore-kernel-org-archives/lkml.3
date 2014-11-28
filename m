Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751265AbaK1ITP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 03:19:15 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:60553 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751155AbaK1ITN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 03:19:13 -0500
Date: Fri, 28 Nov 2014 09:19:05 +0100
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
Message-ID: <20141128091905.3e491c39@armhf>
In-Reply-To: <546B84C6.3090809@arm.com>
References: <546B84C6.3090809@arm.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.25; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Nov 2014 17:41:26 +0000
Andrew Jackson <Andrew.Jackson@arm.com> wrote:

> Fetching the EDID from a connected monitor is an automated thing
> with NXP TDA19988. But on some boards the fetching fails for the
> first time silently without any indication that an error has occured.
> More than that, subsequent fetches of the EDID succeed until the
> monitor(s) are unplugged.
> 
> Add a function to validate the read EDID and retry if the block
> retrieved is not valid.
> 
> Signed-off-by: Andrew Jackson <Andrew.Jackson@arm.com>
> Signed-off-by: Liviu Dudau <Liviu.Dudau@arm.com>

It seems that your patch is deprecated by Laurent Pinchart's
	[PATCH] drm: tda998x: Use drm_do_get_edid()
http://lists.freedesktop.org/archives/dri-devel/2014-November/072906.html

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
