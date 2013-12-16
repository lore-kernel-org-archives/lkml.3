Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab3LPPKb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Dec 2013 10:10:31 -0500
Received: from smtp209.alice.it ([82.57.200.105]:9998 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753762Ab3LPPK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Dec 2013 10:10:29 -0500
Date: Mon, 16 Dec 2013 16:10:18 +0100
From: Antonio Ospite <ospite@studenti.unina.it>
To: David Herrmann <dh.herrmann@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] Input: fix typos in Documentation/input/gamepad.txt
Message-Id: <20131216161018.20e50640f16abcbc14cc17b3@studenti.unina.it>
In-Reply-To: <CANq1E4TUC-Gfu0nkjLOs0BEkxh37pWpqQodK88TW9o96ej5OiQ@mail.gmail.com>
References: <1387197292-29909-1-git-send-email-ospite@studenti.unina.it>
	<CANq1E4TUC-Gfu0nkjLOs0BEkxh37pWpqQodK88TW9o96ej5OiQ@mail.gmail.com>
X-Mailer: Sylpheed 3.4.0beta6 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Dec 2013 14:03:43 +0100
David Herrmann <dh.herrmann@gmail.com> wrote:

> Hi
>

CCing linux-input which I forgot.

> On Mon, Dec 16, 2013 at 1:34 PM, Antonio Ospite
> <ospite@studenti.unina.it> wrote:
> > Fix some typos and while at it also use "PS" as the name for the central
> > "HOME" button on Sony controllers, this is how Sony itself calls it.
> 
> Thanks, looks good. Any news regarding the absolute DPad?
>

I plan on sending a patch to add the individual axes this week.

Any news regarding the ABS_* fixes? :)
Will they make it for 3.14?
I do have an ugly hack to evtest but without the mechanism for
checking the ABS protocol version it's not backward compatible.

> Reviewed-by: David Herrmann <dh.herrmann@gmail.com>
> 
> Thanks
> David
> 
> > Signed-off-by: Antonio Ospite <ospite@studenti.unina.it>
> > ---
> >  Documentation/input/gamepad.txt | 6 +++---
> >  1 file changed, 3 insertions(+), 3 deletions(-)
> >
> > diff --git a/Documentation/input/gamepad.txt b/Documentation/input/gamepad.txt
> > index 4be7f21..63c0256 100644
> > --- a/Documentation/input/gamepad.txt
> > +++ b/Documentation/input/gamepad.txt
> > @@ -71,7 +71,7 @@ features that you need, first. How each feature is mapped is described below.
> >  Legacy drivers often don't comply to these rules. As we cannot change them
> >  for backwards-compatibility reasons, you need to provide fixup mappings in
> >  user-space yourself. Some of them might also provide module-options that
> > -change the mappings so you can adivce users to set these.
> > +change the mappings so you can advice users to set these.
> >
> >  All new gamepads are supposed to comply with this mapping. Please report any
> >  bugs, if they don't.
> > @@ -156,10 +156,10 @@ Menu-Pad:
> >                    BTN_START
> >    Many pads also have a third button which is branded or has a special symbol
> >    and meaning. Such buttons are mapped as BTN_MODE. Examples are the Nintendo
> > -  "HOME" button, the XBox "X"-button or Sony "P" button.
> > +  "HOME" button, the XBox "X"-button or Sony "PS" button.
> >
> >  Rumble:
> > -  Rumble is adverticed as FF_RUMBLE.
> > +  Rumble is advertised as FF_RUMBLE.
> >
> >  Motion-tracking:
> >    Motion-tracking is defined in ./Documentation/input/motion-tracking.txt and
> > --
> > 1.8.5.1
> >
> 

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
