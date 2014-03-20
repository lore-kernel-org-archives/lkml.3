Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758292AbaCTPyc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 11:54:32 -0400
Received: from smtp4-g21.free.fr ([212.27.42.4]:40001 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751671AbaCTPya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 11:54:30 -0400
Date: Thu, 20 Mar 2014 16:54:40 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT
 documentation
Message-ID: <20140320165440.195cd2ea@armhf>
In-Reply-To: <20140320151934.GV7528@n2100.arm.linux.org.uk>
References: <20140320092639.48F68A6279@smtp3-g21.free.fr>
	<532ADFD8.80301@gmail.com>
	<20140320140156.5d768b1f@armhf>
	<532AEDE2.3080306@gmail.com>
	<20140320145221.09252bf6@armhf>
	<20140320143110.GU7528@n2100.arm.linux.org.uk>
	<20140320155935.7a474173@armhf>
	<20140320151934.GV7528@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 15:19:34 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> I'm not saying that it has to match the physical device fitted - I'm
> merely suggesting not using nxp,tda1998x which could (and as Sebastian
> has found, does) conflict with other devices with different properties.
> 
> We still auto-detect the exact device type by reading the ID register
> because that's the most reliable way to detect exactly what kind of
> device is fitted to the board.

I don't see the problem.

Actually the driver handles the tda9989, tda19988 and tda19989 (2
variants). If some board has, for example, the tda9983 and if the
driver is extended to handle this chip (i.e. mainly ignore the CEC
part), setting 'nxp,tda998x' in the associated DT will still work.

There could be a problem if somebody would write a specific driver for,
say, a tda9985. But, then, the compatible would be 'nxp,tda9985'.

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
