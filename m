Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760479AbaGYOFw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 10:05:52 -0400
Received: from smtp206.alice.it ([82.57.200.102]:62473 "EHLO smtp206.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279AbaGYOFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 10:05:51 -0400
Date: Fri, 25 Jul 2014 16:05:27 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 0/4] HID: lenovo: Add support for Lenovo Compact
 Keyboard
Message-Id: <20140725160527.13cbeae1108fce5e09b6daae@ao2.it>
In-Reply-To: <1406154648-14000-1-git-send-email-jm@lentin.co.uk>
References: <1406154648-14000-1-git-send-email-jm@lentin.co.uk>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Jul 2014 23:30:44 +0100
Jamie Lentin <jm@lentin.co.uk> wrote:

> This patchset follows on from my previous attempts to add support for
> these keyboards from Lenovo.
> 
> Antonio, I've used cptkbd_data and left data_pointer for now. It'd be
> an easy patch to change data_pointer to tpkbd_data, but is drifting
> away from what this patchset is supposed to do. Could send that
> afterwards though.
>

Sure, no problem. I think we are good to go.

BTW I was considering picking up one of such compact keyboards myself,
but I read that the BT one uses the USB cable only for charging
and it does not show as a USB HID device when plugged in, can you
confirm that?

Thanks,
   Antonio

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
