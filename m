Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186AbaGNVDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 17:03:18 -0400
Received: from smtp205.alice.it ([82.57.200.101]:32422 "EHLO smtp205.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756878AbaGNVDR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 17:03:17 -0400
Date: Mon, 14 Jul 2014 23:02:56 +0200
From: Antonio Ospite <ao2@ao2.it>
To: Jamie Lentin <jm@lentin.co.uk>
Cc: Jiri Kosina <jkosina@suse.cz>, Hans de Goede <hdegoede@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/4] Add support for Lenovo Compact Keyboard
Message-Id: <20140714230256.9bd2c374a5b7ce085d5064be@ao2.it>
In-Reply-To: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
References: <1405236262-8070-1-git-send-email-jm@lentin.co.uk>
X-Mailer: Sylpheed 3.5.0beta1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
X-Face: z*RaLf`X<@C75u6Ig9}{oW$H;1_\2t5)({*|jhM<pyWR#k60!#=#>/Vb;]yA5<GWI5`6u&+
 ;6b'@y|8w"wB;4/e!7wYYrcqdJFY,~%Gk_4]cq$Ei/7<j&N3ah(m`ku?pX.&+~:_/wC~dwn^)MizBG !pE^+iDQQ1yC6^,)YDKkxDd!T>\I~93>J<_`<4)A{':UrE
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 13 Jul 2014 08:24:18 +0100
Jamie Lentin <jm@lentin.co.uk> wrote:

> This patchset follows on from my previous attempts to add support for
> these keyboards from Lenovo.
[...] 

Hi Jamie,

in the next (and last) iteration add some context to the short commit
message, e.g. by adding a prefix:

HID: lenovo: ...

following the scheme of previous commits in the history.

> Cheers,
> 
> Jamie Lentin (4):
>   Rename hid-lenovo-tpkbd to hid-lenovo
>   Make all base functions switch depending on product ID
>   Style fixes
>   Add support for Compact (Bluetooth|USB) keyboard with Trackpoint

Maybe rename Bluetooth to BT if this becomes too long with the prefix.

Thanks,
   Antonio 

-- 
Antonio Ospite
http://ao2.it

A: Because it messes up the order in which people normally read text.
   See http://en.wikipedia.org/wiki/Posting_style
Q: Why is top-posting such a bad thing?
