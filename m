Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753873Ab3J3SGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 14:06:46 -0400
Received: from bwidawsk.net ([166.78.191.112]:53014 "EHLO mail.bwidawsk.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab3J3SGp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 14:06:45 -0400
Date: Wed, 30 Oct 2013 11:06:41 -0700
From: Ben Widawsky <ben@bwidawsk.net>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm/sysfs: Do not drop device reference twice
Message-ID: <20131030180640.GA13183@bwidawsk.net>
References: <1383130745-32165-1-git-send-email-treding@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1383130745-32165-1-git-send-email-treding@nvidia.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 30, 2013 at 11:59:05AM +0100, Thierry Reding wrote:
> device_unregister() already drops its reference to the struct device, so
> explicitly calling put_device() before device_unregister() can cause the
> device to have been freed before it can be unregistered.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Thanks for fixing this. It was driving me nuts.
Tested-by: Ben Widawsky <ben@bwidawsk.net>

[snip]
-- 
Ben Widawsky, Intel Open Source Technology Center
