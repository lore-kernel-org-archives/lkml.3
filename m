Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754766AbaAMRZa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 12:25:30 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:39991 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754284AbaAMRZ1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 12:25:27 -0500
Date: Mon, 13 Jan 2014 18:24:55 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Rob Clark <robdclark@gmail.com>, dri-devel@lists.freedesktop.org,
        Dave Airlie <airlied@gmail.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 15/28] drm/i2c: tda998x: use the tda998x video format
 when cea mode
Message-ID: <20140113182455.1f8c3f40@armhf>
In-Reply-To: <20140113163501.GB15937@n2100.arm.linux.org.uk>
References: <20140109120448.24d89eba@armhf>
	<20140111181832.GD15937@n2100.arm.linux.org.uk>
	<20140113170707.10b908dc@armhf>
	<20140113161333.GA15937@n2100.arm.linux.org.uk>
	<20140113172220.521917ce@armhf>
	<20140113163501.GB15937@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Jan 2014 16:35:01 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> Ah, I see.  It's a thread about your DRM driver, and about the lack of
> audio on 1080 resolutions.  Taking it in context, the reported issue
> appears to be lack of video when 1080p is selected, but the display
> doesn't support 1080p.  That's hardly surprising.
> 
> Then rabeeh posts his message about lack of audio at 1920x1080.
> 
> Well, I can say that with the tda998x as it stands, the 1080* modes
> work with audio with armada-drm, so there's no need to change this.

My DRM driver also has audio with and without the cea mode for all
resolutions. At the time of Rabeeh's message, I just had forgot to
switch the audio pins...

So, TDA998x CEA mode or not?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
