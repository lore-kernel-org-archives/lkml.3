Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932345Ab3KZTTa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:19:30 -0500
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56042 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab3KZTT2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:19:28 -0500
Date: Tue, 26 Nov 2013 11:19:24 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Subject: Re: input question: ambient light sensor button
Message-ID: <20131126191924.GD22242@core.coreip.homeip.net>
References: <201309151553.34000@pali>
 <201311201550.05800@pali>
 <CAN+gG=HwuES-H4y5=_VcEQg4OiE2NYmra2+MzsbPusiOEq7Qsw@mail.gmail.com>
 <201311221213.49580@pali>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201311221213.49580@pali>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 22, 2013 at 12:13:49PM +0100, Pali Rohár wrote:
> On Wednesday 20 November 2013 16:59:42 Benjamin Tissoires wrote:
> > Hi,
> > 
> > On Wed, Nov 20, 2013 at 9:50 AM, Pali Rohár <pali.rohar@gmail.com> wrote:
> > >> > > I guess we need patch adding
> > >> > > 
> > >> > >   #define KEY_ALS_TOGGLE  0x230
> > >> > > 
> > >> > > Thanks.
> > >> > 
> > >> > So there is no good key for als yet?
> > >> 
> > >> No, but if you send me a patch adding it I will gladly
> > >> apply it.
> > >> 
> > >> Thanks.
> > > 
> > > Ok, here is patch:
> > > 
> > > Add key code for ambient light sensor button
> > > 
> > > More notebooks have special button for enabling/disabling
> > > ambient light sensor. This patch adding new als code to
> > > input.h header file.
> > > 
> > > Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> > > 
> > > diff --git a/include/uapi/linux/input.h
> > > b/include/uapi/linux/input.h index a372627..1562f10 100644
> > > --- a/include/uapi/linux/input.h
> > > +++ b/include/uapi/linux/input.h
> > > @@ -719,6 +719,8 @@ struct input_keymap_entry {
> > > 
> > >  #define BTN_DPAD_LEFT          0x222
> > >  #define BTN_DPAD_RIGHT         0x223
> > > 
> > > +#define KEY_ALS_TOGGLE         0x230
> > 
> > Could you just add a comment explaining that ALS is ambiant
> > light sensor? Otherwise, I'm sure someone else will use this
> > event code for an other thing... :)
> > 
> > Cheers,
> > Benjamin
> 
> Ok, here is new diff with comment:

Applied, thank you.

> 
> diff --git a/include/uapi/linux/input.h b/include/uapi/linux/input.h
> index a372627..7bacdb5 100644
> --- a/include/uapi/linux/input.h
> +++ b/include/uapi/linux/input.h
> @@ -719,6 +719,8 @@ struct input_keymap_entry {
>  #define BTN_DPAD_LEFT		0x222
>  #define BTN_DPAD_RIGHT		0x223
>  
> +#define KEY_ALS_TOGGLE		0x230	/* Ambient light sensor */
> +
>  #define BTN_TRIGGER_HAPPY		0x2c0
>  #define BTN_TRIGGER_HAPPY1		0x2c0
>  #define BTN_TRIGGER_HAPPY2		0x2c1
> 
> 
> -- 
> Pali Rohár
> pali.rohar@gmail.com



-- 
Dmitry
