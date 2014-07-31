Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaGaVOg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 17:14:36 -0400
Received: from aso-006-i451.relay.mailchannels.net ([23.91.64.132]:37523 "EHLO
	relay.mailchannels.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750906AbaGaVOe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 17:14:34 -0400
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-Sender-Id: arvixe|x-authuser|przemo@firszt.eu
X-MC-Relay: Good
X-MailChannels-SenderId: arvixe|x-authuser|przemo@firszt.eu
X-MailChannels-Auth-Id: arvixe
Message-ID: <1406841266.11114.5.camel@fedora-lan>
Subject: Re: [PATCH v3 4/7] Input - wacom: Check for bluetooth protocol
 while setting OLEDs
From: Przemo Firszt <przemo@firszt.eu>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Jason Gerecke <killertofu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-input <linux-input@vger.kernel.org>
Date: Thu, 31 Jul 2014 22:14:26 +0100
In-Reply-To: <CAF8JNhK1R3mzfJA2OZwZv3-KwqpFBkOjDmzM1JkZW_Wix+Ww8g@mail.gmail.com>
References: <1406659385-3256-1-git-send-email-benjamin.tissoires@redhat.com>
	 <1406659385-3256-5-git-send-email-benjamin.tissoires@redhat.com>
	 <1406674412.24026.1.camel@fedora-lan>
	 <CAF8JNhK1R3mzfJA2OZwZv3-KwqpFBkOjDmzM1JkZW_Wix+Ww8g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-AuthUser: przemo@firszt.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dnia 2014-07-31, czw o godzinie 08:56 -0700, Ping Cheng pisze:
[..]
Hi Ping, 
> I'd like to see Przemo's Tested-by tag here as well. Przemo, are you
> done with your testing?

Whole series:
Tested-by: Przemo Firszt <przemo@firszt.eu>

Tested on two Intuos4 Wireless (usb + bt) tablets. Everything works as
expected. 

If someone wants to test icons scrambling in the userspace I added
option to i4oled (switch -B):

https://github.com/PrzemoF/i4oled/tree/v1.3

> Thank you Przemo and Benjamin for your effort in making this
> transition smooth and successful. We, at Wacom, are very grateful to
> be part of this great community.
Thanks! All credit goes to Benjamin :-)
-- 
Kind regards,
Przemo Firszt


