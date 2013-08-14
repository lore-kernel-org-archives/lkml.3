Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759900Ab3HNMSZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 08:18:25 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:41508 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759806Ab3HNMSX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 08:18:23 -0400
Date: Wed, 14 Aug 2013 13:16:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: David Airlie <airlied@linux.ie>, Darren Etheridge <detheridge@ti.com>,
        Rob Clark <robdclark@gmail.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/8] drm/i2c: tda998x: fix EDID reading on TDA19988
	devices
Message-ID: <20130814121606.GB23840@n2100.arm.linux.org.uk>
References: <1375741218-10225-1-git-send-email-sebastian.hesselbarth@gmail.com> <1375741218-10225-2-git-send-email-sebastian.hesselbarth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1375741218-10225-2-git-send-email-sebastian.hesselbarth@gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 06, 2013 at 12:20:11AM +0200, Sebastian Hesselbarth wrote:
> From: Russell King <rmk+kernel@arm.linux.org.uk>
> 
> TDA19988 devices need their RAM enabled in order to read EDID
> information.  Add support for this.
> 
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Tested-by: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>

There was some debate about whether this is needed or not.  It seems that
if I don't run the NXP driver, it isn't needed, but if I have run the
NXP driver, then yes it is.  As it seems to do no harm, I think it's fine
to be submitted.
