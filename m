Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaDHFuR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 01:50:17 -0400
Received: from mail-oa0-f41.google.com ([209.85.219.41]:46169 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbaDHFuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 01:50:15 -0400
MIME-Version: 1.0
X-Originating-IP: [115.42.131.38]
Date: Tue, 8 Apr 2014 13:50:14 +0800
Message-ID: <CAMVG2sti6EMQXw5xyNp-wkq0nGz4zVgz1p7AO48Kb1_zYk8K0w@mail.gmail.com>
Subject: i915 DVI resolution regression (3.13.7+)
From: Daniel J Blueman <daniel@quora.org>
To: =?ISO-8859-1?Q?Ville_Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, Imre Deak <imre.deak@intel.com>,
        intel-gfx@lists.freedesktop.org,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ville et al,

It looks like commit e3ea8fa6beaf55fee64bf816f3b8a80ad733b2c2 (or
another commit in 3.13.7) broke modes which require DVI-D dual-link,
eg 2560x1440 with my panel.

I don't see these modelines in 3.13.7 or later (eg 3.14):

[     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
[     5.582] (II) intel(0): Modeline "2560x1440"x60.0  312.25  2560
2752 3024 3488  1440 1443 1448 1493 -hsync +vsync (89.5 kHz eP)
[     5.582] (II) intel(0): Modeline "1920x1200"x59.9  193.25  1920
2056 2256 2592  1200 1203 1209 1245 -hsync +vsync (74.6 kHz e)

My monitor is a Dell U2713HM; mobo uses an H87 chipset with i5-4670.

Thanks,
  Daniel
-- 
Daniel J Blueman
