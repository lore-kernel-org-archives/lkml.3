Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753657Ab3DVQWv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Apr 2013 12:22:51 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:57335 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab3DVQWt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Apr 2013 12:22:49 -0400
From: "Anna, Suman" <s-anna@ti.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Rusty Russell <rusty@rustcorp.com.au>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        virtualization <virtualization@lists.linux-foundation.org>
Subject: RE: [PATCH 1/2] remoteproc: fix kconfig dependencies for VIRTIO
Thread-Topic: [PATCH 1/2] remoteproc: fix kconfig dependencies for VIRTIO
Thread-Index: AQHOOsgF7mV64147g0aj/LYRoNKrZ5jcI5SA////cYCABOHeAIABbuaQ
Date: Mon, 22 Apr 2013 16:22:43 +0000
Message-ID: <37C860A02101E749A747FA2D3C1E3C504A5E2C@DLEE11.ent.ti.com>
References: <1366133111-5412-1-git-send-email-s-anna@ti.com>
 <CAK=WgbbfT=Ft3GnN1W5A4fg8BDrypgvfeiM3zoRMbW=JS8m+6w@mail.gmail.com>
 <37C860A02101E749A747FA2D3C1E3C504A4F77@DLEE11.ent.ti.com>
 <CAK=Wgbbqh3ugSj=Gc9bN6a1YgLy2M+EOgTOraC04uB3tT=3Rrg@mail.gmail.com>
In-Reply-To: <CAK=Wgbbqh3ugSj=Gc9bN6a1YgLy2M+EOgTOraC04uB3tT=3Rrg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [128.247.5.50]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 18, 2013 at 6:51 PM, Anna, Suman <s-anna@ti.com> wrote:
> >>
> >> On Tue, Apr 16, 2013 at 8:25 PM, Suman Anna <s-anna@ti.com> wrote:
> >> > remoteproc configuration selects VIRTIO, but VIRTIO is now
> >> > subordinate to VIRTUALIZATION. VIRTUALIZATION has to be selected as
> >> > well to honor the kconfig menu hierarchy and fix the dependency warnings.
> >>
> >> Thanks Suman. Is this stable material as well or not relevant before 3.9?
> >
> > No, it is not applicable before 3.9.
> 
> Thanks. We're already at rc7 and it's not urgent, so I plan to push this when the
> merge windows opens with cc stable

Thanks, I agree - it is not a critical fix. 
