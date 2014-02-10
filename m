Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752856AbaBJKme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 05:42:34 -0500
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:53213 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131AbaBJKmc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 05:42:32 -0500
Date: Mon, 10 Feb 2014 10:41:30 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: sagar.a.kamble@intel.com
Cc: intel-gfx@lists.freedesktop.org, vijay.a.purushothaman@intel.com,
        airlied@linux.ie, daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com,
        tomi.valkeinen@ti.com, airlied@redhat.com, robdclark@gmail.com,
        archit@ti.com, gregkh@linuxfoundation.org, joe@perches.com,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/11] Enabling 180 degree rotation for sprite and
 crtc planes
Message-ID: <20140210104130.7e7c3c93@alan.etchedpixels.co.uk>
In-Reply-To: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
References: <1391780716-21896-1-git-send-email-sagar.a.kamble@intel.com>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Feb 2014 19:15:05 +0530
sagar.a.kamble@intel.com wrote:

> From: Sagar Kamble <sagar.a.kamble@intel.com>
> 
> These patches will enable 180 degree rotation for CRTC and Sprite planes.
> Changelog:
> 1. drm/i915: Add 180 degree primary plane rotation support
> Addressed review comments for CRTC rotation from FBC, page flip, CRTC active/
> inactive perspective.

Does this mean it should also handle horizontal mirroring in
hardware (180° rotate, and scan lines backwards combined) ?
