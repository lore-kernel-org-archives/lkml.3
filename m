Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaGBI4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 04:56:52 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35771 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854AbaGBI4u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 04:56:50 -0400
Date: Wed, 2 Jul 2014 10:56:47 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Bryan Wu <cooloney@gmail.com>
cc: Johan Hovold <johan@kernel.org>,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        Greg Kroah-Hartman <greg@kroah.com>,
        =?ISO-8859-15?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        linux-usb@vger.kernel.org,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>
Subject: Re: [PATCH 2/2 v2] HID: leds: Use attribute-groups in MSI GT683R
 driver
In-Reply-To: <CAK5ve-JYjDRfoyTYcc5zRNds-UF=MzK5Jc+31NQYCsEQp5ZHoA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1407021054580.1655@pobox.suse.cz>
References: <20140625115541.GA1409@localhost> <1403711966-13003-1-git-send-email-janne.kanniainen@gmail.com> <20140625174109.GE1409@localhost> <alpine.LNX.2.00.1406252107070.15939@pobox.suse.cz> <CAK5ve-JnqpogKaG1V=mfvKEHMPb8ma4Zeyz9rF4kT-W2Gj=p0A@mail.gmail.com>
 <20140630104744.GB2486@localhost> <alpine.LNX.2.00.1406301330240.28307@pobox.suse.cz> <CAK5ve-+-wkiG6n2Z5aPXQ7gYEDPwcAtPzjOLB+wyi+7h+8=8Hg@mail.gmail.com> <20140701084832.GC1162@localhost>
 <CAK5ve-JYjDRfoyTYcc5zRNds-UF=MzK5Jc+31NQYCsEQp5ZHoA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 1 Jul 2014, Bryan Wu wrote:

> Great, I just cherry-picked and applied to my tree
> http://git.kernel.org/cgit/linux/kernel/git/cooloney/linux-leds.git/commit/?h=for-next&id=f471d9480275796dea2ac7ec249b050e70a2888d

Ok, perfect, thanks. I am marking my 'for-3.17/hid-gt683r' so that it 
wouldn't be contained in the for-linus merge window pile.

-- 
Jiri Kosina
SUSE Labs
