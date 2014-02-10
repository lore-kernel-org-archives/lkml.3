Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412AbaBJOPc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 09:15:32 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53572 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaBJOPb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 09:15:31 -0500
Date: Mon, 10 Feb 2014 14:14:54 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Ville =?UTF-8?B?U3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: sagar.a.kamble@intel.com, daniel.vetter@ffwll.ch,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        vijay.a.purushothaman@intel.com, tomi.valkeinen@ti.com,
        dri-devel@lists.freedesktop.org, gregkh@linuxfoundation.org,
        joe@perches.com, airlied@redhat.com
Subject: Re: [PATCH v4 00/11] Enabling 180 degree rotation for sprite and
 crtc planes
Message-ID: <20140210141454.7f8e25e6@alan.etchedpixels.co.uk>
In-Reply-To: <20140210135212.GN3891@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
	<20140210104130.7e7c3c93@alan.etchedpixels.co.uk>
	<20140210135212.GN3891@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Does this mean it should also handle horizontal mirroring in
> > hardware (180° rotate, and scan lines backwards combined) ?
> 
> Our hardware doesn't support mirroring (h or v). Well, unless you
> count h+v mirroring since that's 180 degree rotation :)
> 
> Anyways IIRC the old video overlay (present on gen2-4) was the only plane
> to ever support mirroring on Intel hardware. With all other planes we're
> limited to 0 and 180 degree rotation

It seems to do vertical mirroring providing your output buffer is
allocated and aligned on page boundaries as the GTT can then be used to
map the scan lines in any order you like ?

Alan
