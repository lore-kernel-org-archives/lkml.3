Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934171Ab3CHOj0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Mar 2013 09:39:26 -0500
Received: from mga09.intel.com ([134.134.136.24]:61018 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757682Ab3CHOjZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Mar 2013 09:39:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,809,1355126400"; 
   d="scan'208";a="274122450"
Date: Fri, 8 Mar 2013 14:39:22 +0000
From: Damien Lespiau <damien.lespiau@intel.com>
To: Syam Sidhardhan <syamsidhardh@gmail.com>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, airlied@linux.ie,
        Paulo Zanoni <przanoni@gmail.com>
Subject: Re: [PATCH] drm/i915: Fix missing variable initilization
Message-ID: <20130308143922.GA3071@dyon.amr.corp.intel.com>
References: <1361745338-28522-1-git-send-email-s.syam@samsung.com>
 <20130303172026.GG9021@phenom.ffwll.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130303172026.GG9021@phenom.ffwll.local>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 03, 2013 at 06:20:26PM +0100, Daniel Vetter wrote:
> On Mon, Feb 25, 2013 at 04:05:38AM +0530, Syam Sidhardhan wrote:
> > Need to initialize the variable wait to false.
> > 
> > Signed-off-by: Syam Sidhardhan <s.syam@samsung.com>
> 
> Looks sane, thanks for the patch. Cc'ing Paulo in case I've missed
> something.

FWIW, I posted a similar patch (without moving the variable around) on
intel-gfx yesterday, so:

Reviewed-by: Damien Lespiau <damien.lespiau@intel.com>

-- 
Damien
