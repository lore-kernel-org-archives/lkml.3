Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3ASQav (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2013 11:30:51 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:60958 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab3ASQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2013 11:30:50 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <50FAC93C.3040205@ionic.de>
References: <50F9DF53.4090601@ionic.de>
	<CAKMK7uExHc=PEBpn2vPrX+sQcv=U7VuvsJHRxc-SSOh=_G_1Dg@mail.gmail.com>
	<50FAC61A.9060503@ionic.de>
	<50FAC93C.3040205@ionic.de>
Date: Sat, 19 Jan 2013 17:30:47 +0100
Message-ID: <CAKMK7uF5Pu0oQ650qR-Bmkw8T9NYo9CQYjSarvY_-RpgRQT0Ew@mail.gmail.com>
Subject: Re: i915-related and general system freezes with specific kernel
 config // IOMMU
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Mihai Moldovan <ionic@ionic.de>
Cc: LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 19, 2013 at 5:26 PM, Mihai Moldovan <ionic@ionic.de> wrote:
> The current patch errors out on my while compiling as quirk_iommu_rwbf is not
> yet defined at that place.

Oops, attached an old patch, updated one should work better.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
