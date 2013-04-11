Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3DKFQz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 01:16:55 -0400
Received: from mail-la0-f49.google.com ([209.85.215.49]:52913 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752493Ab3DKFQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 01:16:53 -0400
MIME-Version: 1.0
In-Reply-To: <CACraW2pORbuy-OfZq=NANBLzKhPYWXBzFJfzZa+k2SHyuCdqZQ@mail.gmail.com>
References: <20130409172820.GC27612@phenom.ffwll.local>
	<1365537090-11518-1-git-send-email-daniel.vetter@ffwll.ch>
	<20130410115901.GA4502@netboy>
	<20130410120724.GJ27612@phenom.ffwll.local>
	<20130410172717.GA2480@netboy>
	<CACraW2pORbuy-OfZq=NANBLzKhPYWXBzFJfzZa+k2SHyuCdqZQ@mail.gmail.com>
Date: Thu, 11 Apr 2013 08:16:51 +0300
X-Google-Sender-Auth: fhOhV5bFIBB0AuVzPboHnC8c2Ug
Message-ID: <CACraW2pN4+d4Cx7kA_HLc0AKippt1gV2e0kOD0Dng=+_pUai8w@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: don't check inconsistent modeset state when force-restoring
From: Tomas Melin <tomas.melin@iki.fi>
To: Richard Cochran <richardcochran@gmail.com>, daniel.vetter@ffwll.ch
Cc: Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Dave Airlie <airlied@gmail.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 10, 2013 at 9:32 PM, Tomas Melin <tomas.melin@iki.fi> wrote:
> On Tue, Apr 9, 2013 at 10:51 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> v2: Try harder not to create a big patch (Chris).
>>
> Tested the patch applied to 3.9-rc6. Atleast on my machine that
> helped, although once I managed to get the error (but not warning and
> call trace as before):
> [drm:i9xx_crtc_mode_set] *ERROR* Couldn't find PLL settings for mode!
>

Update: the situation where I still get an error is if the machine is
in standby with the lid open. Then close and open will generate that
kind of error. The patch however fixes the original problem.

thanks,
Tomas
