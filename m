Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757121Ab3HMJxl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:53:41 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:60510 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757078Ab3HMJxj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:53:39 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Tue, 13 Aug 2013 10:52:59 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "s.dilek" <s.dilek@jpberlin.de>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical
 mode ]
Message-ID: <20130813095259.GC4519@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Sedat Dilek <sedat.dilek@gmail.com>,
	Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Dave Airlie <airlied@gmail.com>,
	DRI <dri-devel@lists.freedesktop.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	"s.dilek" <s.dilek@jpberlin.de>
References: <CA+icZUWmee5nTZCGvFb4vLpna5vUn+RJ-V9pHpKPFaTc96BG5Q@mail.gmail.com>
 <20130813092554.GA4519@cantiga.alporthouse.com>
 <CA+icZUUrJt_sJqp0CNMuM_b36tvv_rUskegLY5zcnm0w+JcW5Q@mail.gmail.com>
 <20130813093920.GB4519@cantiga.alporthouse.com>
 <CA+icZUVEcCTbBre99FWiDXRAMKcdQxUagXE-2-rO9g=YVUAieQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUVEcCTbBre99FWiDXRAMKcdQxUagXE-2-rO9g=YVUAieQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 11:47:19AM +0200, Sedat Dilek wrote:
> On Tue, Aug 13, 2013 at 11:39 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> > On Tue, Aug 13, 2013 at 11:35:53AM +0200, Sedat Dilek wrote:
> >> After a logout from my "BROKEN" Unity-2D session - the login-screen
> >> for LightDM seems to be OK.
> >> Then entering my Unity-2D desktop is OK - no screen corruptions.
> >
> > What hardware and display do you have?
> 
> It's a Samsung ultrabook with SandyBridge CPU.
> 
> [   333.291] (--) intel(0): Integrated Graphics Chipset: Intel(R) HD
> Graphics 3000

using LVDS.
 
> - Sedat -
> 
> P.S.: I switched to intel-ddx v2-21-14-35-g5840bf in the meantime.

Did that make a difference? It shouldn't if the error is occuring before
X even starts...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
