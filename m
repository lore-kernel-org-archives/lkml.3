Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425AbaC0IU4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 04:20:56 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:61001 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752420AbaC0IUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 04:20:52 -0400
Date: Thu, 27 Mar 2014 08:20:47 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel@stlinux.com, Brian Norris <computersforpeace@gmail.com>,
        MTD Maling List <linux-mtd@lists.infradead.org>, angus.clark@st.com
Subject: Re: [PATCH 01/15] mtd: st_spi_fsm: Add Macronix MX25L25655E device
Message-ID: <20140327082047.GB26627@lee--X1>
References: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
 <1395851969-13520-2-git-send-email-lee.jones@linaro.org>
 <CAMuHMdXgPiJSrA4Txp_OxrGx7osNsprm5a+w3Qag=Yd-_nFVBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdXgPiJSrA4Txp_OxrGx7osNsprm5a+w3Qag=Yd-_nFVBw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

> > From: Angus Clark <angus.clark@st.com>
> >
> > Add Macronix MX25L25655E to the list of known devices.
> >
> > Signed-off-by: Angus Clark <angus.clark@st.com>
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/mtd/devices/st_spi_fsm.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> > index bea1416..2471061 100644
> > --- a/drivers/mtd/devices/st_spi_fsm.c
> > +++ b/drivers/mtd/devices/st_spi_fsm.c
> > @@ -380,6 +380,9 @@ static struct flash_info flash_types[] = {
> >         { "mx25l25635e", 0xc22019, 0, 64*1024, 512,
> >           (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70,
> >           stfsm_mx25_config },
> > +       { "mx25l25655e", 0xc22619, 0, 64*1024, 512,
> > +         (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70,
> > +         stfsm_mx25_config},
> >
> >  #define N25Q_FLAG (FLASH_FLAG_READ_WRITE       |       \
> >                    FLASH_FLAG_READ_FAST         |       \
> 
> How much of this table can be shared with the one in m25p80.c?

I have a long term plan to merge the two. Just waiting for the SPI NOR
Framework to land before I do so.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
