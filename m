Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752189AbaJTRA3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:00:29 -0400
Received: from casper.infradead.org ([85.118.1.10]:46438 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750962AbaJTRA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:00:26 -0400
Message-ID: <54453FA4.3090009@infradead.org>
Date: Mon, 20 Oct 2014 10:00:20 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, airlied@linux.ie,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        corbet@lwn.net, trivial@kernel.org
Subject: Re: [PATCH] gpu:drm: Fix typo in Documentation/DocBook/drm.xml
References: <1413816793-14690-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1413816793-14690-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/14 07:53, Masanari Iida wrote:
> This patch fix spelling typos found in drm.xml.
> It is because the file is generated from comments in
> source codes, I have to fix the typos within source files.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  drivers/gpu/drm/drm_crtc.c             | 2 +-
>  drivers/gpu/drm/drm_irq.c              | 4 ++--
>  drivers/gpu/drm/drm_modes.c            | 2 +-
>  drivers/gpu/drm/drm_prime.c            | 4 ++--
>  drivers/gpu/drm/i915/i915_cmd_parser.c | 4 ++--
>  drivers/gpu/drm/i915/i915_reg.h        | 2 +-
>  drivers/gpu/drm/i915/intel_lrc.c       | 2 +-
>  include/drm/drm_dp_mst_helper.h        | 2 +-
>  8 files changed, 11 insertions(+), 11 deletions(-)


-- 
~Randy
