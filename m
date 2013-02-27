Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab3B0Wgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2013 17:36:47 -0500
Received: from mail-wi0-f169.google.com ([209.85.212.169]:35476 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab3B0Wgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2013 17:36:46 -0500
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
Date: Wed, 27 Feb 2013 23:36:44 +0100
Message-ID: <CA+icZUXG7WgRap2-oQGBr_s=QbE0QW6_zChDRqC-eEzrWR3Y5g@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Sedat Dilek <sedat.dilek@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Dave Airlie <airlied@gmail.com>, DRI <dri-devel@lists.freedesktop.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-next <linux-next@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am seeing this also on Linux-Next.

/var/log/kern.log:Feb 27 22:52:35 fambox kernel: [   28.202381]
[drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
(has irq: 1)!
/var/log/kern.log:Feb 27 22:52:35 fambox kernel: [   28.210588]
[drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
(has irq: 1)!

/var/log/kern.log.1:Feb 22 07:36:04 fambox kernel: [   27.408280]
[drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not signal timeout
(has irq: 1)!

This seems to be hard reproducible...
Laptop-LCD... Sandybridge Mobile-GT2.

Is there a way to force the error?

Possible patch see [1].

- Sedat -

[1] https://patchwork.kernel.org/patch/2192721/
