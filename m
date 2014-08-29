Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163AbaH2HaY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 03:30:24 -0400
Received: from mail-ig0-f175.google.com ([209.85.213.175]:42849 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbaH2HaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 03:30:21 -0400
Date: Fri, 29 Aug 2014 08:30:17 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Jingoo Han <jg1.han@samsung.com>
Cc: linux-kernel@vger.kernel.org, "'Bryan Wu'" <cooloney@gmail.com>
Subject: Re: [PATCH V2 00/18] backlight: fix checkpatch warnings
Message-ID: <20140829073017.GB24579@lee--X1>
References: <004301cfc193$69c1de20$3d459a60$%han@samsung.com>
 <20140827071402.GX26707@lee--X1>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140827071402.GX26707@lee--X1>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Aug 2014, Lee Jones wrote:

> On Wed, 27 Aug 2014, Jingoo Han wrote:
> > This patchset fixes checkpatch warnings as follows.
> > There is no functional change.
> > 
> >    WARNING: Missing a blank line after declarations
> >    WARNING: else is not generally useful after a break or return
> >    WARNING: void function return statements are not generally useful
> > 
> > Changes for V2
> > - Added Lee Jones's Acked-by for 1~18th patches, except for 17th patch.
> > - Fixed 17th patch, per Lee Jones's feedback.
> >    
> > Jingoo Han (18)
> >       backlight: adp5520: add blank line after declarations
> >       backlight: adp8860: add blank line after declarations
> >       backlight: adp8870: add blank line after declarations
> >       backlight: ams369fg06: remove 'else' after a return
> >       backlight: corgi_lcd: add blank line after declarations
> >       backlight: cr_bllcd: add blank line after declarations
> >       backlight: ili922x: remove 'else' after a return
> >       backlight: ld9040: remove 'else' after a return
> >       backlight: lm3639: remove unnecessary return statements
> >       backlight: lms501kf03: remove 'else' after a return
> >       backlight: lp855x: add blank line after declarations
> >       backlight: pcf50633: add blank line after declarations
> >       backlight: s6e63m0: remove 'else' after a return
> >       backlight: tdo24m: add blank line after declarations
> >       backlight: wm831x_bl: add blank line after declarations
> >       backlight: jornada720: remove 'else' after a return
> >       backlight: jornada720: remove 'else' after a return
> >       backlight: omap1: add blank line after declarations
> 
> I'll wait to see if Bryan has anything to add.  If not, I'll apply
> them in a couple of days.

All patches applied and pushed.

> > ---
> >  drivers/video/backlight/adp5520_bl.c         |  1 +
> >  drivers/video/backlight/adp8860_bl.c         |  3 +++
> >  drivers/video/backlight/adp8870_bl.c         |  4 ++++
> >  drivers/video/backlight/ams369fg06.c         |  6 +++---
> >  drivers/video/backlight/corgi_lcd.c          |  1 +
> >  drivers/video/backlight/cr_bllcd.c           |  1 +
> >  drivers/video/backlight/ili922x.c            | 11 ++++++-----
> >  drivers/video/backlight/jornada720_bl.c      |  6 +++---
> >  drivers/video/backlight/jornada720_lcd.c     |  6 +-----
> >  drivers/video/backlight/ld9040.c             |  6 +++---
> >  drivers/video/backlight/lm3639_bl.c          |  2 --
> >  drivers/video/backlight/lms501kf03.c         | 12 ++++++------
> >  drivers/video/backlight/lp855x_bl.c          |  2 ++
> >  drivers/video/backlight/omap1_bl.c           |  1 +
> >  drivers/video/backlight/pcf50633-backlight.c |  1 +
> >  drivers/video/backlight/s6e63m0.c            | 12 ++++++------
> >  drivers/video/backlight/tdo24m.c             |  2 ++
> >  drivers/video/backlight/wm831x_bl.c          |  1 +
> >  18 files changed, 45 insertions(+), 33 deletions(-)
> > 
> > 
> 

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
