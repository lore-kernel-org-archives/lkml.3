Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966778Ab3HHWFx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Aug 2013 18:05:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54163 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966733Ab3HHWFw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Aug 2013 18:05:52 -0400
Date: Thu, 8 Aug 2013 17:08:40 -0500
From: Darren Etheridge <detheridge@ti.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
CC: David Airlie <airlied@linux.ie>, Rob Clark <robdclark@gmail.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        <dri-devel@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] Several NXP TDA998x patches
Message-ID: <20130808220840.GA23078@ti.com>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote on Tue [2013-Aug-06 00:20:10 +0200]:
> This patch set picks up several patches sent during the past months
> related with NXP TDA998x HDMI transmitter driver. The patches have
> been tested on Marvell Dove (Armada DRM) on several HDMI modes with
> audio playing on S/PDIF. I have also quickly tested on Beaglebone
> Black (tilcdc) for one DVI mode.
> 
> As I squashed some patches and fixed some audio issues, it would
> be great to have a formal Tested-by or Acked-by from Russell and
> Darren for the whole patch set.
> 
Sebastian,

Looks good to me, I tried this series with all the known "problem"
modes on the BeagleBone Black and they are working correctly now.

I should just state for the record that I have so far tested DVI mode
(no audio) and only boot time mode setting but this is all we have
been using from the original mainline NXP/tilcdc drm drivers anyway.

So for the series:
Tested-by: Darren Etheridge <detheridge@ti.com>

Darren
