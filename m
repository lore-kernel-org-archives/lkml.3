Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaB0Itl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Feb 2014 03:49:41 -0500
Received: from mga09.intel.com ([134.134.136.24]:20406 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750844AbaB0Itk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Feb 2014 03:49:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,553,1389772800"; 
   d="scan'208";a="490767687"
Date: Thu, 27 Feb 2014 10:49:36 +0200
From: Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To: Carl Worth <cworth@cworth.org>
Cc: intel-gfx@lists.freedesktop.org, David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH] drm/i915/dp: Allow for 5.4Gbps for Haswell.
Message-ID: <20140227084936.GI3852@intel.com>
References: <1393488699-6265-1-git-send-email-cworth@cworth.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1393488699-6265-1-git-send-email-cworth@cworth.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 27, 2014 at 12:11:39AM -0800, Carl Worth wrote:
> With Haswell, 5.4Gbps is supported. And almost all of the code was
> already in place already. All that was missing was this tiny bit of
> additional wiring.

Todd already implemented 5.4Gbps support a while back. So it seems your
tree is a bit out of date.

-- 
Ville Syrjälä
Intel OTC
