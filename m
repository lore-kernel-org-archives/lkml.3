Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757645AbaDIFrJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 01:47:09 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:38692 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbaDIFrG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 01:47:06 -0400
Date: Tue, 8 Apr 2014 22:47:00 -0700
From: Brian Norris <computersforpeace@gmail.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kernel@stlinux.com, MTD Maling List <linux-mtd@lists.infradead.org>,
        angus.clark@st.com
Subject: Re: [PATCH 01/15] mtd: st_spi_fsm: Add Macronix MX25L25655E device
Message-ID: <20140409054700.GC3131@norris-Latitude-E6410>
References: <1395851969-13520-1-git-send-email-lee.jones@linaro.org>
 <1395851969-13520-2-git-send-email-lee.jones@linaro.org>
 <CAMuHMdXgPiJSrA4Txp_OxrGx7osNsprm5a+w3Qag=Yd-_nFVBw@mail.gmail.com>
 <20140327082047.GB26627@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140327082047.GB26627@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 08:20:47AM +0000, Lee Jones wrote:
> > > From: Angus Clark <angus.clark@st.com>
> > >
> > > Add Macronix MX25L25655E to the list of known devices.
> > >
> > > Signed-off-by: Angus Clark <angus.clark@st.com>
> > > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > > ---
> > >  drivers/mtd/devices/st_spi_fsm.c | 3 +++
> > >  1 file changed, 3 insertions(+)
> > >
> > > diff --git a/drivers/mtd/devices/st_spi_fsm.c b/drivers/mtd/devices/st_spi_fsm.c
> > > index bea1416..2471061 100644
> > > --- a/drivers/mtd/devices/st_spi_fsm.c
> > > +++ b/drivers/mtd/devices/st_spi_fsm.c
> > > @@ -380,6 +380,9 @@ static struct flash_info flash_types[] = {
> > >         { "mx25l25635e", 0xc22019, 0, 64*1024, 512,
> > >           (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70,
> > >           stfsm_mx25_config },
> > > +       { "mx25l25655e", 0xc22619, 0, 64*1024, 512,
> > > +         (MX25_FLAG | FLASH_FLAG_32BIT_ADDR | FLASH_FLAG_RESET), 70,
> > > +         stfsm_mx25_config},
> > >
> > >  #define N25Q_FLAG (FLASH_FLAG_READ_WRITE       |       \
> > >                    FLASH_FLAG_READ_FAST         |       \
> > 
> > How much of this table can be shared with the one in m25p80.c?
> 
> I have a long term plan to merge the two. Just waiting for the SPI NOR
> Framework to land before I do so.

Huang's work landed in the spinor branch at l2-mtd.git a bit ago. I will
take a look at this series and probably take this as-is, but long-term I
will not be taking many more additions to this custom table.

Regards,
Brian
