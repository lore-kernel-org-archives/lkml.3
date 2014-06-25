Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880AbaFYNWb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 09:22:31 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:64921 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753576AbaFYNW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 09:22:29 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Date: Wed, 25 Jun 2014 14:22:20 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Tom Van Braeckel <tomvanbraeckel@gmail.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        David Airlie <airlied@linux.ie>, ville.syrjala@linux.intel.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: drm/i915 KMS regression in Linux 3.16-rc2 (with git bisect
 result)
Message-ID: <20140625132220.GA20837@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Tom Van Braeckel <tomvanbraeckel@gmail.com>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	David Airlie <airlied@linux.ie>, ville.syrjala@linux.intel.com,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <CAJ7vePCSE3eWTBpzBGY8-e3ZTB0iZARdfMmhRE6LQYaxcFkVqg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ7vePCSE3eWTBpzBGY8-e3ZTB0iZARdfMmhRE6LQYaxcFkVqg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 03:03:44PM +0200, Tom Van Braeckel wrote:
> Hi,
> 
> There seems to be a regression in the upcoming Linux 3.16-rc2 release
> candidate that I bisected down to this first bad commit:
> [dbb42748ac4929987c1449ecb296b39ef8956b62] drm/i915: Move the C3 LP
> write bit setup to gen3_init_clock_gating() for KMS.

Can you attach the dmesg with rc2 and dbb4274 reverted?
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
