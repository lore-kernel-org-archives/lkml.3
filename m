Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062AbaIHOWa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 10:22:30 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:59631 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753846AbaIHOW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:22:29 -0400
Date: Mon, 8 Sep 2014 19:52:13 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Morgan Reece <winter2718@gmail.com>
Cc: Brian Johnson <brijohn@gmail.com>, Hans de Goede <hdegoede@redhat.com>,
        m.chehab@samsung.com, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, wolfram@the-dreams.de
Subject: Re: [PATCH] [media]: sn9c20x.c: fix checkpatch error: that open
 brace { should be on the previous line
Message-ID: <20140908142213.GA23444@sudip-PC>
References: <1410179542-3272-1-git-send-email-winter2718@gmail.com>
 <20140908134828.GA7617@sudip-PC>
 <CAGztXF1YXAMJhCrO_AmH115DX7NFfNmXzVefUBnVH2H9vkxNYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGztXF1YXAMJhCrO_AmH115DX7NFfNmXzVefUBnVH2H9vkxNYg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 08, 2014 at 08:51:18AM -0500, Morgan Reece wrote:
> Hi Sudip,
> 
> I searched through the logs for examples of messages where people had just
> fixed checkpatch errors.  I found lots like this, so went the format, ex:
> 
> commit 588a12d789e1a9b8193465c09f32024c0d43a849
> Author: Filipe Gonçalves <filipe@codinghighway.com>
> Date:   Fri Sep 5 05:09:46 2014 +0100
> 
>     staging/lustre: Fixed checkpatch warning: Use #include <linux/statfs.h>
> instead of <asm/statfs.h>
> 
this is the commit log.
whatever you write above your Signed-off-by goes as the commit log.
ideally commit log should have the full details of the change you have done ,
and the reason behind the change.
Incidentally , if you see all mails of today , you will find one of my patch 
as rejected because my commit log was not explanatory.

thanks
sudip

>     Signed-off-by: Filipe Gonçalves <filipe@codinghighway.com>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> 
> On Mon, Sep 8, 2014 at 8:48 AM, Sudip Mukherjee <sudipm.mukherjee@gmail.com>
> wrote:
> 
> > On Mon, Sep 08, 2014 at 07:32:22AM -0500, Morgan Phillips wrote:
> > > Signed-off-by: Morgan Phillips <winter2718@gmail.com>
> >
> > no commit message ?
> >
> > thanks
> > sudip
> >
> > > ---
> > >  drivers/media/usb/gspca/sn9c20x.c | 10 ++++++----
> > >  1 file changed, 6 insertions(+), 4 deletions(-)
> > >
> > > diff --git a/drivers/media/usb/gspca/sn9c20x.c
> > b/drivers/media/usb/gspca/sn9c20x.c
> > > index 41a9a89..95467f0 100644
> > > --- a/drivers/media/usb/gspca/sn9c20x.c
> > > +++ b/drivers/media/usb/gspca/sn9c20x.c
> > > @@ -1787,8 +1787,9 @@ static int sd_init(struct gspca_dev *gspca_dev)
> > >       struct sd *sd = (struct sd *) gspca_dev;
> > >       int i;
> > >       u8 value;
> > > -     u8 i2c_init[9] =
> > > -             {0x80, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > 0x03};
> > > +     u8 i2c_init[9] = {
> > > +             0x80, sd->i2c_addr, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
> > 0x03
> > > +     };
> > >
> > >       for (i = 0; i < ARRAY_SIZE(bridge_init); i++) {
> > >               value = bridge_init[i][1];
> > > @@ -2242,8 +2243,9 @@ static void sd_pkt_scan(struct gspca_dev
> > *gspca_dev,
> > >  {
> > >       struct sd *sd = (struct sd *) gspca_dev;
> > >       int avg_lum, is_jpeg;
> > > -     static const u8 frame_header[] =
> > > -             {0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96};
> > > +     static const u8 frame_header[] = {
> > > +             0xff, 0xff, 0x00, 0xc4, 0xc4, 0x96
> > > +     };
> > >
> > >       is_jpeg = (sd->fmt & 0x03) == 0;
> > >       if (len >= 64 && memcmp(data, frame_header, 6) == 0) {
> > > --
> > > 1.9.1
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-kernel"
> > in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > > Please read the FAQ at  http://www.tux.org/lkml/
> >
