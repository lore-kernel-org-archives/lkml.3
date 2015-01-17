Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752300AbbAQWPX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 17:15:23 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40690 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751607AbbAQWPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 17:15:22 -0500
Date: Sat, 17 Jan 2015 14:15:17 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Antonio Ospite <ao2@ao2.it>
Cc: Shailendra Verma <shailendra.capricorn@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 8/9] Fixed indentation violation in switch statement :
 Aligned the "switch" and its subordinate "case" labels in the same column
 instead of "double-intending" the "case" labels.
Message-ID: <20150117221517.GB38334@dtor-ws>
References: <1421495625-21558-1-git-send-email-shailendra.capricorn@gmail.com>
 <20150117161316.66645bebb64e7f46218d7daa@ao2.it>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150117161316.66645bebb64e7f46218d7daa@ao2.it>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 17, 2015 at 04:13:16PM +0100, Antonio Ospite wrote:
> On Sat, 17 Jan 2015 17:23:45 +0530
> Shailendra Verma <shailendra.capricorn@gmail.com> wrote:
> 
> > 
> > Signed-off-by: Shailendra Verma <shailendra.capricorn@gmail.com>
> > ---
> >  drivers/input/evdev.c    |   30 ++++++++++++++++++++----------
> >  drivers/input/mousedev.c |   18 ++++++++++++------
> >  2 files changed, 32 insertions(+), 16 deletions(-)
> > 
> > diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> > index 18d4b2c..85ee594 100644
> > --- a/drivers/input/evdev.c
> > +++ b/drivers/input/evdev.c
> > @@ -667,16 +667,26 @@ static int handle_eviocgbit(struct input_dev *dev,
> >  
> >  	switch (type) {
> >  
> > -	case      0: bits = dev->evbit;  len = EV_MAX;  break;
> > -	case EV_KEY: bits = dev->keybit; len = KEY_MAX; break;
> > -	case EV_REL: bits = dev->relbit; len = REL_MAX; break;
> > -	case EV_ABS: bits = dev->absbit; len = ABS_MAX; break;
> > -	case EV_MSC: bits = dev->mscbit; len = MSC_MAX; break;
> > -	case EV_LED: bits = dev->ledbit; len = LED_MAX; break;
> > -	case EV_SND: bits = dev->sndbit; len = SND_MAX; break;
> > -	case EV_FF:  bits = dev->ffbit;  len = FF_MAX;  break;
> > -	case EV_SW:  bits = dev->swbit;  len = SW_MAX;  break;
> > -	default: return -EINVAL;
> 
> I have the feeling this formatting was deliberate, to make comparing the
> lines easier, see the alignment after colons and semicolons.

Yes, I'd rather kept the code here and in mousedev as is.

Thanks.

-- 
Dmitry
