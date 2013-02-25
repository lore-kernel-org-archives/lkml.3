Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757491Ab3BYOjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 09:39:36 -0500
Received: from mga14.intel.com ([143.182.124.37]:12417 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753561Ab3BYOjd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 09:39:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,735,1355126400"; 
   d="scan'208";a="206032959"
Date: Mon, 25 Feb 2013 14:39:18 +0000
From: Chris Wilson <chris@chris-wilson.co.uk>
To: Felipe Balbi <balbi@ti.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: i915 not working on Dell e6410
Message-ID: <20130225143918.GA19874@cantiga.alporthouse.com>
Mail-Followup-To: Chris Wilson <chris@chris-wilson.co.uk>,
	Felipe Balbi <balbi@ti.com>, Daniel Vetter <daniel.vetter@ffwll.ch>,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org
References: <20130225142411.GD15499@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130225142411.GD15499@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 04:24:11PM +0200, Felipe Balbi wrote:
> Hi folks,
> 
> I have a Dell e6410 whose framebuffer gets corrupted with v3.7.9 and
> v3.8.0 but works fine with v3.6.11.
> 
> Below you can find lspci and my .config, maybe I'm missing something ?

You don't describe how the fb gets corrupted, so it is impossible to
guess the likely cause. When in doubt, please attach a photograph of
the corruption.
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
