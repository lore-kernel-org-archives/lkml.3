Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842AbaEVLyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 07:54:23 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55622 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaEVLyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 07:54:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Christophe Kerello <christophe.kerello@st.com>,
        computersforpeace@gmail.com, linux-mtd@lists.infradead.org
Subject: Re: [PATCH 09/10] mtd: st_spi_fsm: Provide mask to obtain correct boot device pins
Date: Thu, 22 May 2014 13:53:52 +0200
Message-ID: <6459516.cEryHnqAem@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140522115216.GV6679@lee--X1>
References: <1400757848-18075-1-git-send-email-lee.jones@linaro.org> <4231397.Nn7Rm5jh2O@wuerfel> <20140522115216.GV6679@lee--X1>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:iGAHU/7VDSu66jEZdcTu7odxDTqrN3xb2+QXU4UE89j
 oFVtBr8/h9yjTuNsaw3/q7RT/zuNDrj4HAueCFWhw78teFmyGk
 UCzXsstH4hEWIlrTi+2HsUD9RQNvvQDM9/Q4axGU4FFuUfXQI0
 sQsGWBOhXbshMgn66ukH+Pnn44IeGFEiJp6tbYOBGrTYB77vxZ
 Vy1EKdGFyZl1aHNO7MWnFtUmHqZuhUWvSGYoFbjl1SijYuncAa
 qap9+7kNk7/knFzah6rrrFaw20nAvcrcHyJmJMrjsUywa9frd0
 Qbt3pXvaU4vgbWWpDT8uuLjBdjtQV92maNOIm9Q42KZRwOAF4A
 cdlb4foJF+KmVJ0/4Go4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 22 May 2014 12:52:16 Lee Jones wrote:
> > On Thursday 22 May 2014 12:24:07 Lee Jones wrote:
> > > +       /* Mask to apply on boot_device_reg */
> > > +       ret = of_property_read_u32(np, "st,boot-device-msk", &boot_device_msk);
> > > +       if (ret)
> > > +               goto boot_device_fail;
> > > +
> > > 
> > 
> > The binding defines this property as "optional", but the driver fails
> > here if it's not provided. I suggest you add a default value here so you
> > can deal with existing dts. The default should be documented in
> > the binding as well.
> 
> The property is optional. It doesn't fail completely, merely skips the
> boot device check and falls back to using SPI.  I can update the
> documentation to this effect though, no problem.

Ah, I see, thanks for the explanation!

	Arnd
