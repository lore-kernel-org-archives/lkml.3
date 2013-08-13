Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757209Ab3HMJ5R (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 05:57:17 -0400
Received: from mail-we0-f182.google.com ([74.125.82.182]:49755 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756924Ab3HMJ5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 05:57:14 -0400
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20130813095259.GC4519@cantiga.alporthouse.com>
References: <CA+icZUWmee5nTZCGvFb4vLpna5vUn+RJ-V9pHpKPFaTc96BG5Q@mail.gmail.com>
	<20130813092554.GA4519@cantiga.alporthouse.com>
	<CA+icZUUrJt_sJqp0CNMuM_b36tvv_rUskegLY5zcnm0w+JcW5Q@mail.gmail.com>
	<20130813093920.GB4519@cantiga.alporthouse.com>
	<CA+icZUVEcCTbBre99FWiDXRAMKcdQxUagXE-2-rO9g=YVUAieQ@mail.gmail.com>
	<20130813095259.GC4519@cantiga.alporthouse.com>
Date: Tue, 13 Aug 2013 11:57:13 +0200
Message-ID: <CA+icZUX6KM3dKrdX3Qkwg-DeBYobjQ+WG6oQEUjJQG3Q=qf+Sg@mail.gmail.com>
Subject: Re: linux-next: Tree for Aug 13 [ screen corruption in graphical mode ]
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>,
        Sedat Dilek <sedat.dilek@gmail.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        "s.dilek" <s.dilek@jpberlin.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 13, 2013 at 11:52 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, Aug 13, 2013 at 11:47:19AM +0200, Sedat Dilek wrote:
>> On Tue, Aug 13, 2013 at 11:39 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > On Tue, Aug 13, 2013 at 11:35:53AM +0200, Sedat Dilek wrote:
>> >> After a logout from my "BROKEN" Unity-2D session - the login-screen
>> >> for LightDM seems to be OK.
>> >> Then entering my Unity-2D desktop is OK - no screen corruptions.
>> >
>> > What hardware and display do you have?
>>
>> It's a Samsung ultrabook with SandyBridge CPU.
>>
>> [   333.291] (--) intel(0): Integrated Graphics Chipset: Intel(R) HD
>> Graphics 3000
>
> using LVDS.
>
>> - Sedat -
>>
>> P.S.: I switched to intel-ddx v2-21-14-35-g5840bf in the meantime.
>
> Did that make a difference? It shouldn't if the error is occuring before
> X even starts...

NO, was just confused not seeing "GT2" (HD-3000 was new to me) in my
Xorg.log :-).

As said logging out of Unity-2D and entering LightDM greeter - screen is fine.
Starting again a Unity-2D session - no screen corruption, too.

- Sedat -
