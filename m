Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754074Ab3LRQgh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 11:36:37 -0500
Received: from mail-pa0-f54.google.com ([209.85.220.54]:44804 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752692Ab3LRQgf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 11:36:35 -0500
Date: Wed, 18 Dec 2013 08:36:30 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: Antonio Ospite <ospite@studenti.unina.it>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Benjamin Tissoires <benjamin.tissoires@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Input Tools <input-tools@lists.freedesktop.org>
Subject: Re: [PATCH 2/4] Input: introduce ABS_MAX2/CNT2 and friends
Message-ID: <20131218163630.GA30922@core.coreip.homeip.net>
References: <1387295334-1744-1-git-send-email-dh.herrmann@gmail.com>
 <1387295334-1744-3-git-send-email-dh.herrmann@gmail.com>
 <20131218152731.0222ae3b3807601b7756c937@studenti.unina.it>
 <CANq1E4RNa6XBaUTy=ur7Yig0iJSEaUbLzvi-Dn-hyxS2OLnyPw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANq1E4RNa6XBaUTy=ur7Yig0iJSEaUbLzvi-Dn-hyxS2OLnyPw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 03:44:48PM +0100, David Herrmann wrote:
> >>
> >>  /*
> >> + * Due to API restrictions the legacy evdev API only supports ABS values up to
> >> + * ABS_MAX/CNT. Use the extended *ABS2 ioctls to operate on any ABS values in
> >> + * between ABS_MAX and ABS_MAX2.
> >> + */
> >> +#define ABS_MAX2             0x3f
> >> +#define ABS_CNT2             (ABS_MAX2+1)
> >> +
> >
> > Maybe it's just my English, but when you say "between ABS_MAX and
> > ABS_MAX2" it sounds like the old protocol still _must_ be used for
> > values <= ABS_MAX.
> >
> > IIUC this is true "only" for compatibility with older kernels right?
> > If a program decides to support only newer kernels it can check the
> > protocol version and use only the new ioctls, right?
> >
> > Maybe you can be more explicit about that in the comment?
> 
> See the comment on "struct input_absinfo2". It describes the API, this
> comment just describes the ABS_* values. But if anyone has a better
> phrase to use here, I will gladly adjust it.

"Use the extended *ABS2 ioctls to access the full range of ABS values
supported by the kernel."

?

-- 
Dmitry
