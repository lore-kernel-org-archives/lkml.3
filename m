Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753100AbaF0KFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 06:05:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52416 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752826AbaF0KFu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 06:05:50 -0400
Date: Fri, 27 Jun 2014 12:05:46 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Bryan Wu <cooloney@gmail.com>, Johan Hovold <johan@kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>,
        Janne Kanniainen <janne.kanniainen@gmail.com>,
        =?ISO-8859-15?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH 00/13] leds: fix attribute-creation races
In-Reply-To: <20140626232506.GA26949@kroah.com>
Message-ID: <alpine.LNX.2.00.1406271204480.21386@pobox.suse.cz>
References: <1403716136-32694-1-git-send-email-johan@kernel.org> <CAK5ve-JVBoeW+a+1PKcfCwNOC+HOdKUD=1iFrTJAZ_tqh10yuQ@mail.gmail.com> <20140626232506.GA26949@kroah.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 26 Jun 2014, Greg Kroah-Hartman wrote:

> > Thanks a lot for driving this. I will applied this patchset into my
> > -devel branch. After I got the Ack from Input guys, I will apply it to
> > my for-next branch then.
> 
> Series looks good to me, Johan, thanks for doing this work.

Yeah, looks good to me as well, thanks. The lm8323 change should be Acked 
by Dmitry though, as it's in his area.

-- 
Jiri Kosina
SUSE Labs
