Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419AbaCMAJu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 20:09:50 -0400
Received: from mail.fireflyinternet.com ([87.106.93.118]:61287 "EHLO
	fireflyinternet.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751490AbaCMAJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 20:09:49 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.73.22;
Date: Wed, 12 Mar 2014 23:52:09 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Pavel Machek <pavel@ucw.cz>
Cc: daniel.vetter@ffwll.ch, jani.nikula@linux.intel.com,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        kernel list <linux-kernel@vger.kernel.org>
Subject: Re: WARN_ON() and X session lost from i915 on 3.14-rc6
Message-ID: <20140312235209.GA4615@nuc-i3427.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Pavel Machek <pavel@ucw.cz>, daniel.vetter@ffwll.ch,
	jani.nikula@linux.intel.com, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	kernel list <linux-kernel@vger.kernel.org>
References: <20140312233039.GA5582@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140312233039.GA5582@amd.pavel.ucw.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 12:30:39AM +0100, Pavel Machek wrote:
> Hi!
> 
> This cost me two half-written mails...
> 
> So far it happened once, so it may be very infrequent; but I do not
> think I seen similar failure from i915 before, so it may be an
> regression. Well...

It's a userspace use-after-free bug. Please file a bug on
bugs.freedesktop.org.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
