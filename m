Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762288Ab3IDKIT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Sep 2013 06:08:19 -0400
Received: from s16502780.onlinehome-server.info ([87.106.93.118]:64577 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752866Ab3IDKIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Sep 2013 06:08:18 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Wed, 4 Sep 2013 11:08:14 +0100
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: daniel.vetter@ffwll.ch, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: 3.11-rc7: i915: stuck on render ring
Message-ID: <20130904100814.GH24319@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Pavel Machek <pavel@ucw.cz>, daniel.vetter@ffwll.ch,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	kernel list <linux-kernel@vger.kernel.org>
References: <20130903190646.GA9616@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130903190646.GA9616@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: 78.156.73.22
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 03, 2013 at 09:06:47PM +0200, Pavel Machek wrote:
> Hi!
> 
> I was happily using X... and then screen froze. Mouse still
> moves. Switching to text console still worked, good. It is first time
> in a while, normally this machine works well.
> 
> i915_error_state is attached.
> 
> Any ideas?

It's a bug in the ddx, that was fixed in 2.14.902 (2011-03-29).
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
