Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751485AbaAMJ07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 04:26:59 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:53438 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751283AbaAMJ04 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:26:56 -0500
Date: Mon, 13 Jan 2014 10:26:24 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: dri-devel@lists.freedesktop.org, Rob Clark <robdclark@gmail.com>,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 23/28] drm/i2c: tda998x: add the active aspect in
 HDMI AVI frame
Message-ID: <20140113102624.04d270ce@armhf>
In-Reply-To: <20140111185114.GK15937@n2100.arm.linux.org.uk>
References: <20140109120639.5f76c620@armhf>
 <20140111185114.GK15937@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014 18:51:14 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> On Thu, Jan 09, 2014 at 12:06:39PM +0100, Jean-Francois Moine wrote:
> > This patch adds the active aspect as 'picture' in the HDMI AVI frame
> > and also some comments about this frame.
> 
> Yes, this should've been set.  It's probably a stable tree candidate,
> but first it needs testing.

I get correct 4:3 (1280x960) and 5:4 (1280x1024) images on my 16:9 TV
screen with this aspect value. 16:10 (1680x1050) images are stretched.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
