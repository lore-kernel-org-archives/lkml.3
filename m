Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871AbaKLOLU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 09:11:20 -0500
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62941 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752686AbaKLOLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 09:11:15 -0500
Date: Wed, 12 Nov 2014 15:11:31 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: David Airlie <airlied@linux.ie>, linaro-kernel@lists.linaro.org,
        patches@linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Benjamin Gaignard <benjamin.gaignard@linaro.org>,
        Joonyoung Shim <jy0922.shim@samsung.com>
Subject: Re: [PATCH v2 v3.18-rc4 2/4] drm: prime: Document gem_prime_mmap
Message-ID: <20141112141131.GU25711@phenom.ffwll.local>
Mail-Followup-To: Daniel Thompson <daniel.thompson@linaro.org>,
	David Airlie <airlied@linux.ie>, linaro-kernel@lists.linaro.org,
	patches@linaro.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	Benjamin Gaignard <benjamin.gaignard@linaro.org>,
	Joonyoung Shim <jy0922.shim@samsung.com>
References: <1415639805-17477-1-git-send-email-daniel.thompson@linaro.org>
 <1415792295-2466-1-git-send-email-daniel.thompson@linaro.org>
 <1415792295-2466-3-git-send-email-daniel.thompson@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415792295-2466-3-git-send-email-daniel.thompson@linaro.org>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2014 at 11:38:13AM +0000, Daniel Thompson wrote:
> gem_prime_map is not currently described in the DRM manual, lets document
> it.
> 
> Signed-off-by: Daniel Thompson <daniel.thompson@linaro.org>

Patches 1&2 are Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>

Nit: Since this fixes an oversight in an earlier patch I usally cc the
people of the offending patch:

commit 7c397cd97b8f46659698396b420bd48c3e6703e6
Author: Joonyoung Shim <jy0922.shim@samsung.com>
Date:   Fri Jun 28 14:24:53 2013 +0900

    drm: add mmap function to prime helpers

Cheers, Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
