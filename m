Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754544AbaELGeU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 02:34:20 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:50563 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753015AbaELGeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 02:34:17 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Mon, 12 May 2014 07:33:55 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Dave Airlie <airlied@gmail.com>,
        "intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Thomas Meyer <thomas@m3y3r.de>
Subject: Re: [Intel-gfx] 3.15-rc5: Regression in i915 driver?
Message-ID: <20140512063355.GA3813@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	"intel-gfx@lists.freedesktop.org" <intel-gfx@lists.freedesktop.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Thomas Meyer <thomas@m3y3r.de>
References: <1399796911.2442.7.camel@localhost.localdomain>
 <CAPM=9tzwkwSTC2i=KWSxmHkG74fXyyh8JiTzEaDwNgg-J_G7cw@mail.gmail.com>
 <CAKMK7uG4Gnn_sY44Ci8VbRhJQf8=5s_dod4tRX+PDYYs1EYFsQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uG4Gnn_sY44Ci8VbRhJQf8=5s_dod4tRX+PDYYs1EYFsQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 11, 2014 at 07:40:57PM +0200, Daniel Vetter wrote:
> On Sun, May 11, 2014 at 11:02 AM, Dave Airlie <airlied@gmail.com> wrote:
> > On 11 May 2014 18:28, Thomas Meyer <thomas@m3y3r.de> wrote:
> >> Hi,
> >>
> >> 3.14.3 works as expected.
> >> 3.15-rc5 shows a strange behaviour: When resuming from ram the X server
> >> seems to be disfunctional.
> >>
> >> I see this WARNING in the kernel log before suspend to ram in the early
> >> boot process:
> 
> Doesn't ring a bell really.

Same symptoms as
https://bugs.freedesktop.org/show_bug.cgi?id=76554
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
