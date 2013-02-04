Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755867Ab3BDOvl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Feb 2013 09:51:41 -0500
Received: from mail-wi0-f170.google.com ([209.85.212.170]:58785 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab3BDOvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Feb 2013 09:51:39 -0500
Date: Mon, 4 Feb 2013 15:53:50 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Tejun Heo <tj@kernel.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rusty@rustcorp.com.au, bfields@fieldses.org, skinsbursky@parallels.com,
        ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 17/62] drm/i915: convert to idr_alloc()
Message-ID: <20130204145350.GC5843@phenom.ffwll.local>
Mail-Followup-To: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org, rusty@rustcorp.com.au,
	bfields@fieldses.org, skinsbursky@parallels.com,
	ebiederm@xmission.com, jmorris@namei.org, axboe@kernel.dk,
	David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
References: <1359854463-2538-1-git-send-email-tj@kernel.org>
 <1359854463-2538-18-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1359854463-2538-18-git-send-email-tj@kernel.org>
X-Operating-System: Linux phenom 3.8.0-rc3+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Feb 02, 2013 at 05:20:18PM -0800, Tejun Heo wrote:
> Convert to the much saner new idr interface.
> 
> Only compile tested.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
> Cc: dri-devel@lists.freedesktop.org
> ---
> This patch depends on an earlier idr changes and I think it would be
> best to route these together through -mm.  Please holler if there's
> any objection.  Thanks.

Indeed, this looks nice.

Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
