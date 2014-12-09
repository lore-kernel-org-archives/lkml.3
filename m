Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaLIOJh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 09:09:37 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:57597 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756957AbaLIOJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 09:09:34 -0500
Date: Tue, 9 Dec 2014 16:09:27 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: linux-leds@vger.kernel.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        Andrzej Hajda <a.hajda@samsung.com>, Lee Jones <lee.jones@linaro.org>,
        Chanwoo Choi <cw00.choi@samsung.com>, devicetree@vger.kernel.org
Subject: Re: [PATCH/RFC v9 06/19] DT: Add documentation for the mfd Maxim
 max77693
Message-ID: <20141209140927.GL15559@valkosipuli.retiisi.org.uk>
References: <1417622814-10845-1-git-send-email-j.anaszewski@samsung.com>
 <1417622814-10845-7-git-send-email-j.anaszewski@samsung.com>
 <20141204100706.GP14746@valkosipuli.retiisi.org.uk>
 <54804840.4030202@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54804840.4030202@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Thu, Dec 04, 2014 at 12:40:48PM +0100, Jacek Anaszewski wrote:
> >>+			the flash/torch.
> >>+- maxim,trigger : Array of flags indicating which trigger can activate given led
> >>+	in order: fled1, fled2.
> >>+	Possible flag values (can be combined):
> >>+		MAX77693_LED_TRIG_FLASHEN - FLASHEN pin of the chip,
> >>+		MAX77693_LED_TRIG_TORCHEN - TORCHEN pin of the chip,
> >>+		MAX77693_LED_TRIG_SOFTWARE - software via I2C command.
> >
> >Is there a need to prevent strobing using a certain method? Just wondering.
> 
> In some cases it could be convenient to prevent some options through
> device tree.

Do you have that need now?

If not, I'd propose to postpone this and add it only if there ever is one.

-- 
Kind regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
