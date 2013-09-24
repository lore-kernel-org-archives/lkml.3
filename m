Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3IXJCG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Sep 2013 05:02:06 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51975 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753589Ab3IXJBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Sep 2013 05:01:51 -0400
Date: Tue, 24 Sep 2013 11:02:08 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Thomas Richter <thor@math.tu-berlin.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: [Intel-gfx] i835GM flicker on panning
Message-ID: <20130924090208.GB13668@phenom.ffwll.local>
Mail-Followup-To: Thomas Richter <thor@math.tu-berlin.de>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	intel-gfx <intel-gfx@lists.freedesktop.org>
References: <alpine.SOC.1.00.1308261610280.25531@math.ut.ee>
 <alpine.SOC.1.00.1309211825490.9193@math.ut.ee>
 <4319_1379778790_523DC0E3_4319_13540_1_CAKMK7uHynzChMurTLAYMfeRF07aDJxes-6eSO1iDbrET8xD84Q@mail.gmail.com>
 <523F2390.5030702@math.tu-berlin.de>
 <16566_1379880205_523F4D0D_16566_5011_1_CAKMK7uFNAhahpURH-LFj=x+8D2W7Z8y_-9OKhnJ_O4g7hyqu1Q@mail.gmail.com>
 <523F7020.702@math.tu-berlin.de>
 <17822_1379921548_523FEE8C_17822_1617_1_20130923073242.GA32145@phenom.ffwll.local>
 <5240162A.2030404@math.tu-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5240162A.2030404@math.tu-berlin.de>
X-Operating-System: Linux phenom 3.10-2-amd64
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 12:21:30PM +0200, Thomas Richter wrote:
> Hi folks,
> 
> >Can you please test with
> >
> >        Option "LinearFramebuffer" "true"?
> >
> >Thanks, Daniel
> 
> Tested again. Yes, indeed, LinearFramebuffer does make a difference.
> Without it, panning to the right causes flicker, with it, moving the
> mouse to the right - panning right (thus scrolling the screen to the
> left) causes no flicker. Scrolling into the other direction always
> causes flicker, no matter what.

Hm, this is something I've completely missed thus far: Does the flicker
only happen when you pan, or also when the image is at a stable postion
(but not aligned to one of the safe boundaries you've identified)?

Thanks, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
