Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753245Ab3IWHc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 03:32:27 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:43025 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3IWHcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 03:32:25 -0400
Date: Mon, 23 Sep 2013 09:32:42 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Richter <thor@math.tu-berlin.de>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: i835GM flicker on panning
Message-ID: <20130923073242.GA32145@phenom.ffwll.local>
Mail-Followup-To: Thomas Richter <thor@math.tu-berlin.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>
References: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee>
 <alpine.SOC.1.00.1309211825490.9193@math.ut.ee>
 <4319_1379778790_523DC0E3_4319_13540_1_CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
 <523F2390.5030702@math.tu-berlin.de>
 <16566_1379880205_523F4D0D_16566_5011_1_CAKMK7uFNAhahpURH-LFj=x+8D2W7Z8y_-9OKhnJ_O4g7hyqu1Q@mail.gmail.com>
 <523F7020.702@math.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <523F7020.702@math.tu-berlin.de>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:33:04AM +0200, Thomas Richter wrote:
> On 22.09.2013 22:03, Daniel Vetter wrote:
> >Hm, that sounds a bit more like the ddx is having fun with rendering.
> >Have you tried switching the backed from to either SNA or UXA? Also
> >adding relevant mailing lists ...
> >
> No, whether I use uxa or sna makes no difference, same problem. I
> don't think it's rendering related. The rendering is ok (except for
> some defects in tuxracer if sna is used instead of uxa).

Can you please test with

       Option "LinearFramebuffer" "true"?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
