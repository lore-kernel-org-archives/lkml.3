Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491AbaLOLqM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 06:46:12 -0500
Received: from mail-la0-f42.google.com ([209.85.215.42]:52037 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbaLOLqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 06:46:11 -0500
MIME-Version: 1.0
In-Reply-To: <20141215073156.GK27182@phenom.ffwll.local>
References: <CA+i8gKK0sj55s-Gk8Y36KM4yBFLvLotffbSodjH5Gsd_yxd5Sg@mail.gmail.com>
	<CAKMK7uGa_dHnie8EACcX0mQvc-uGpsgQHjWGN_obxPa3O6SJbw@mail.gmail.com>
	<CA+i8gKKGBviLBaS8b=swqv2OWgh2Uc+m-TT8LVYcPehcYd903A@mail.gmail.com>
	<CA+i8gKJPPPUXrxY5q+81xZG91azygoUb27R_Wid3GTpb3-1-rw@mail.gmail.com>
	<20141215073156.GK27182@phenom.ffwll.local>
Date: Mon, 15 Dec 2014 12:46:09 +0100
Message-ID: <CA+i8gKKKOjvawuL_Wfi454H=-ghMh727B_te7SVjCQgSrmt-rg@mail.gmail.com>
Subject: Re: [Regression] 83f45fc turns machine's screen off
From: Emmanuel Benisty <benisty.e@gmail.com>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Dave Airlie <airlied@linux.ie>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 15, 2014 at 8:31 AM, Daniel Vetter <daniel@ffwll.ch> wrote:

[---snip---]

> Sorry for the delay. Absolutely no difference in the relevant parts of the
> log. There could be the chance that something is hidden somewhere, so can
> please grab a new set of logs but this time with drm.debug=0xe?

Thanks for your reply Daniel. However, former logs were already
generated with drm.debug=0xe.
