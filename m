Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758055AbaDWVJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 17:09:50 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:35817 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757969AbaDWVJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 17:09:45 -0400
MIME-Version: 1.0
X-Originating-IP: [84.73.67.144]
In-Reply-To: <20140423202248.GA3621@amd.pavel.ucw.cz>
References: <20140423202248.GA3621@amd.pavel.ucw.cz>
Date: Wed, 23 Apr 2014 23:09:45 +0200
Message-ID: <CAKMK7uFT5eW8Y8kKvWO1P_aN=SHgP+bZWB8fO2mATKaO=_DNjA@mail.gmail.com>
Subject: Re: 3.15-rc2: i915 regression: only top 20% of screen works in X
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Pavel Machek <pavel@ucw.cz>
Cc: "Nikula, Jani" <jani.nikula@linux.intel.com>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 10:22 PM, Pavel Machek <pavel@ucw.cz> wrote:
> After update to 3.15-rc2, only top 20% of screen works on X.
>
> 00:02.0 VGA compatible controller: Intel Corporation 4 Series Chipset
> Integrated Graphics Controller (rev 03)
>
> 00:02.1 Display controller: Intel Corporation 4 Series Chipset
> Integrated Graphics Controller (rev 03)
>            Subsystem: Intel Corporation Device d614
>            Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop-
>            ParErr- Stepping- SERR- FastB2B- DisINTx-
>            Status: Cap+ 66MHz- UDF- FastB2B+ ParErr- DEVSEL=fast
>            >TAbort- <TAbort- <MAbort- >SERR- <PERR- INTx-
>            Latency: 0
>            Region 0: Memory at d0400000 (64-bit, non-prefetchable)
>            [size=1M]
>            Capabilities: <access denied>
>
> This worked before. I believe it worked in 3.14. It definitely works
> in 3.11-rc2.

Screenshot or more detailed description of what "only top 20% of
screen works in X" means?
Anything in dmesg?
bisect result presuming that it reproduces reliably?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
