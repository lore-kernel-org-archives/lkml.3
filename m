Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758654AbaCTNY5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:24:57 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:35366 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757872AbaCTNYz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:24:55 -0400
X-Greylist: delayed 1392 seconds by postgrey-1.27 at vger.kernel.org; Thu, 20 Mar 2014 09:24:54 EDT
Date: Thu, 20 Mar 2014 14:25:08 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Jean-Francois Moine <moinejf@free.fr>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT
 documentation
Message-ID: <20140320142508.557fb860@armhf>
In-Reply-To: <20140320140156.5d768b1f@armhf>
References: <20140320092639.48F68A6279@smtp3-g21.free.fr>
	<532ADFD8.80301@gmail.com>
	<20140320140156.5d768b1f@armhf>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 14:01:56 +0100
Jean-Francois Moine <moinejf@free.fr> wrote:

> For other boards using the TDA998x family, if the I2C address is
> different from 0x70, have you an idea about what can be the CEC I2C
> address? (this value is actually hard-coded in the TDA998x driver)

I had a look again on the tda998x driver from NXP and the linux tda998x
driver:

- the NXP driver handles the TDAs 19989, 19988, 9984, 9983 and 9981.
  It accesses the tda registers only at I2C address 0x70 and 0x34
  (hard-coded values in the driver).

- the linux tda998x driver handles only the TDAs 19988 and 19989.

As we have no documentation about the chips TDA 19988 and 19989,
may the HDMI I2C addresses of these chips be different from 0x70?

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
