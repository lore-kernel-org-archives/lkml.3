Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934016AbaCTO7Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 10:59:25 -0400
Received: from smtp3-g21.free.fr ([212.27.42.3]:55438 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933542AbaCTO7V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 10:59:21 -0400
Date: Thu, 20 Mar 2014 15:59:35 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT
 documentation
Message-ID: <20140320155935.7a474173@armhf>
In-Reply-To: <20140320143110.GU7528@n2100.arm.linux.org.uk>
References: <20140320092639.48F68A6279@smtp3-g21.free.fr>
	<532ADFD8.80301@gmail.com>
	<20140320140156.5d768b1f@armhf>
	<532AEDE2.3080306@gmail.com>
	<20140320145221.09252bf6@armhf>
	<20140320143110.GU7528@n2100.arm.linux.org.uk>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 14:31:10 +0000
Russell King - ARM Linux <linux@arm.linux.org.uk> wrote:

> 1. change the DT compatible strings the driver has to accept both
>    nxp,tda19988 and nxp,tda19989, and set the appropriate device
>    in the DT file (tda19988).  I'm a bit nervous about using
>    "nxp,tda1998x" in case we're clashing with devices with different
>    characteristics.

The Cubox is sold with either the TDA19988 or the TDA19989 (I don't
know about the AMX33XX boards). Then, setting the exact type in the DT
would ask for 2 differents DTs or for having two tda998x definitions in
a same DT...

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
