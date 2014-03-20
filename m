Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757914AbaCTNBo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 09:01:44 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:43279 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226AbaCTNBm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 09:01:42 -0400
Date: Thu, 20 Mar 2014 14:01:56 +0100
From: Jean-Francois Moine <moinejf@free.fr>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ASoC: tda998x: Fix lack of required reg in DT
 documentation
Message-ID: <20140320140156.5d768b1f@armhf>
In-Reply-To: <532ADFD8.80301@gmail.com>
References: <20140320092639.48F68A6279@smtp3-g21.free.fr>
	<532ADFD8.80301@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Mar 2014 13:32:24 +0100
Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:

> > +  - reg: I2C address - must be <0x70>  
> 
> TDA9983b datasheet says:
> 
> "Bits A0 and A1 of the I2C-bus device address are externally selected
> by pins A0 and A1."
> 
> Therefore, 0x70, 0x71, 0x72, and 0x73 are valid i2c addresses.

Sebastian,

That's interesting!

For the Cubox and the AMX33XX boards, the I2C address of the HDMI
registers is 0x70, and the I2C address of the CEC registers is 0x34.

For other boards using the TDA998x family, if the I2C address is
different from 0x70, have you an idea about what can be the CEC I2C
address? (this value is actually hard-coded in the TDA998x driver)

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
