Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932340Ab3B0CZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2013 21:25:59 -0500
Received: from mail-ve0-f176.google.com ([209.85.128.176]:49078 "EHLO
	mail-ve0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755381Ab3B0CZ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2013 21:25:58 -0500
MIME-Version: 1.0
In-Reply-To: <CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
References: <alpine.DEB.2.00.1302260003460.24684@skynet.skynet.ie>
	<CA+55aFzRRxTjuQcLhkhfxDWpHEg3EoSY8CMP+v78i+_Z-EkQ1g@mail.gmail.com>
Date: Tue, 26 Feb 2013 18:25:57 -0800
X-Google-Sender-Auth: 3GgUL_m3eUMYNh58ducxgoEBiU4
Message-ID: <CA+55aFzmJSmdhQhn45DGZ9vWCPXxttkBiFqjFu0B-s3t3_EzUA@mail.gmail.com>
Subject: Re: [git pull] drm merge for 3.9-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Airlie <airlied@linux.ie>, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Imre Deak <imre.deak@intel.com>
Cc: DRI mailing list <dri-devel@lists.freedesktop.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 26, 2013 at 5:39 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Lowlight:
>
> [    5.710827] [drm:intel_dp_aux_wait_done] *ERROR* dp aux hw did not
> signal timeout (has irq: 1)!

Oh, forgot to mention - this is my trusty old Westmere chip (aka "Core
i5-670", aka Clarkdale, aka GMA-some-random-number). The one before
SB.

               Linus
