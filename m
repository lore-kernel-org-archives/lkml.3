Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755013AbaAMQfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 11:35:13 -0500
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:35776 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754795AbaAMQfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:35:09 -0500
Date: Mon, 13 Jan 2014 16:35:01 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 15/28] drm/i2c: tda998x: use the tda998x video
	format when cea mode
Message-ID: <20140113163501.GB15937@n2100.arm.linux.org.uk>
References: <20140109120448.24d89eba@armhf> <20140111181832.GD15937@n2100.arm.linux.org.uk> <20140113170707.10b908dc@armhf> <20140113161333.GA15937@n2100.arm.linux.org.uk> <20140113172220.521917ce@armhf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140113172220.521917ce@armhf>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 05:22:20PM +0100, Jean-Francois Moine wrote:
> On Mon, 13 Jan 2014 16:13:34 +0000
> Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:
> 
> > Sorry, I don't see what bearing your response to my reply has.
> 
> Simply that NXP people better like to use the cea mode.

Ah, I see.  It's a thread about your DRM driver, and about the lack of
audio on 1080 resolutions.  Taking it in context, the reported issue
appears to be lack of video when 1080p is selected, but the display
doesn't support 1080p.  That's hardly surprising.

Then rabeeh posts his message about lack of audio at 1920x1080.

Well, I can say that with the tda998x as it stands, the 1080* modes
work with audio with armada-drm, so there's no need to change this.

-- 
FTTC broadband for 0.8mile line: 5.8Mbps down 500kbps up.  Estimation
in database were 13.1 to 19Mbit for a good line, about 7.5+ for a bad.
Estimate before purchase was "up to 13.2Mbit".
