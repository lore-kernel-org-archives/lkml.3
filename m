Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755258Ab3AKSmU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 13:42:20 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:48235 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754824Ab3AKSmT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 13:42:19 -0500
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <8738y7skae.fsf@redhat.com>
References: <20130108223611.GA19672@kroah.com>
	<20130109003824.GA21075@kroah.com>
	<CAPM=9tw3o0e_3cRUFntwddxsWMsYkVKe1b5gDQhxijYKU=9m5g@mail.gmail.com>
	<20130109042533.GA9164@kroah.com>
	<CAPM=9tyB4aKK2Z3-h9yEXLWvrnKGjxH2DaOHp8uA0mNNZQiVWQ@mail.gmail.com>
	<50ED1C12.2090608@gmail.com>
	<50EDC8A1.30307@oracle.com>
	<50EDCF14.4080101@oracle.com>
	<8738y7skae.fsf@redhat.com>
Date: Fri, 11 Jan 2013 19:42:17 +0100
Message-ID: <CAKMK7uGpAHRgT3aj6bvU-13gaFe0u8gq19nDfo86JCJJy3R-tw@mail.gmail.com>
Subject: Re: i915_hangcheck_hung problem with 3.8-rc2+ (Linus's latest tree)
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Nikola Pajkovsky <npajkovs@redhat.com>
Cc: Dave Kleikamp <dave.kleikamp@oracle.com>,
        Lijo Antony <lijo.kernel@gmail.com>, Dave Airlie <airlied@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 11, 2013 at 6:26 PM, Nikola Pajkovsky <npajkovs@redhat.com> wrote:
> bug still kicking even w/ (drm/i915: Revert shrinker changes from "Track
> unbound pages")

Could be a different bug, can you please attach the error_state somewhere?
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
