Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945982Ab3FUT5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Jun 2013 15:57:50 -0400
Received: from stator.leun.net ([85.214.203.199]:46034 "EHLO stator.leun.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1945935Ab3FUT5t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Jun 2013 15:57:49 -0400
Date: Fri, 21 Jun 2013 21:57:17 +0200
From: Michael Leun <lkml20130126@newton.leun.net>
To: Netdev <netdev@vger.kernel.org>
Cc: Rami Rosen <roszenrami@gmail.com>, Patrick McHardy <kaber@trash.net>,
        shemminger@linux-foundation.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Missing iproute2 support for 802.1ad
Message-ID: <20130621215717.528b3cbf@xenia.leun.net>
In-Reply-To: <20130621173744.1c1ce920@xenia.leun.net>
References: <20130620231713.4f6a3c1f@xenia.leun.net>
	<CAKoUArm0w70TZvaZSMa1C9vAj+UXsMkza7XTBX0Vq-7B3xrFLA@mail.gmail.com>
	<CAKoUArnyR+6bk9UU3GuyteznX-wWVQUfWuaiVuS0YOSKCKKF5w@mail.gmail.com>
	<20130621173744.1c1ce920@xenia.leun.net>
Organization: Not Organized
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Jun 2013 17:37:44 +0200
Michael Leun <lkml20130126@newton.leun.net> wrote:

> On Fri, 21 Jun 2013 16:52:41 +0300
> Rami Rosen <roszenrami@gmail.com> wrote:
> 
> > This patch by Patrick McHardy, titled:
> > "add 802.1ad support", seems to do the job:
> > http://www.spinics.net/lists/netdev/msg233587.html

> OK, when applying that patch to iproute2 git the if_link.h hunk
> expectedly fails, but the rest applies.

Meanwhile Stephen has grabbed that patch and committed it to iproute2
git - thank you very much.

> But, unfortunately the result is not what I would expect:
[...]
> Both have ether type 0x8100, the first one should have 0x88a8, or did
> I get something wrong?

This either was an problem with veth or with namespace or with both of
them.

With real ethernet I get the same result Patrick has shown in his
802.1aq commit message.

-- 
MfG,

Michael Leun

