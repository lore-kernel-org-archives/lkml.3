Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754212Ab3K0LIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:08:49 -0500
Received: from mail.fireflyinternet.com ([87.106.93.118]:50202 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752983Ab3K0LIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:08:48 -0500
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Wed, 27 Nov 2013 11:08:36 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Jan Engelhardt <jengelh@inai.de>
Cc: daniel.vetter@ffwll.ch, dri-devel@lists.freedesktop.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: i915: pipe state still does not match
Message-ID: <20131127110836.GA6087@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Jan Engelhardt <jengelh@inai.de>, daniel.vetter@ffwll.ch,
	dri-devel@lists.freedesktop.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <alpine.LSU.2.11.1311271156060.20996@nerf07.vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.11.1311271156060.20996@nerf07.vanv.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:59:56AM +0100, Jan Engelhardt wrote:
> Greetings.
> 
> 
> Despite the i915/drm fixes added in v3.11.8, the X server still 
> terminates due to some pipe state bug in 3.11.9.
> 
> I have a fb setup to span two crtcs in below's configuration,
> and the kernel problem is easily triggerable for me by moving
> an Xv window (such as by using mplayer) forth and back
> between the two crtc.
> The problem did not exist in 3.9.9.
> 
> > xrandr
> Screen 0: minimum 320 x 200, current 1280 x 1624, maximum 32767 x 32767
> LVDS1 connected primary 1024x600+0+1024 (normal left inverted right x axis y axis) 220mm x 129mm
>    1024x600       60.0*+
>    800x600        60.3     56.2  
>    640x480        59.9  
> VGA1 connected 1280x1024+0+0 (normal left inverted right x axis y axis) 376mm x 301mm
>    1280x1024      60.0*+   75.0     72.0  
>    1152x864       75.0  
>    1024x768       75.1     70.1     60.0  
>    832x624        74.6  
>    800x600        72.2     75.0     60.3  
>    640x480        75.0     72.8     66.7     60.0  
>    720x400        70.1  
>    640x350        70.1  
> VIRTUAL1 disconnected (normal left inverted right x axis y axis)

X terminating is entirely unconnected with that *ERROR*. Can you please
attach your Xorg.0.log with the crash information?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
