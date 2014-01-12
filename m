Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751497AbaALSv6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jan 2014 13:51:58 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:40217 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750956AbaALSv4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jan 2014 13:51:56 -0500
Date: Sun, 12 Jan 2014 19:51:13 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        Rob Clark <robdclark@gmail.com>, Dave Airlie <airlied@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 13/28] drm/i2c: tda998x: use irq for connection
 status and EDID read
Message-ID: <20140112195113.316d0c98@armhf>
In-Reply-To: <52D18EE9.5030305@gmail.com>
References: <20140109120412.7697d23c@armhf>
	<20140111181432.GB15937@n2100.arm.linux.org.uk>
	<52D18EE9.5030305@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 11 Jan 2014 19:35:21 +0100
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> At least for the DT part, I'd suggest to not ask for interrupt directly
> but use a proper gpios property. The can of course be converted to
> priv->int_irq in some tda998x_dt_probe.

May you give me more information?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
