Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754428Ab3E1J7v (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 05:59:51 -0400
Received: from mail-ee0-f45.google.com ([74.125.83.45]:46502 "EHLO
	mail-ee0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752235Ab3E1J7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 05:59:49 -0400
Date: Tue, 28 May 2013 11:59:43 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: daniel.vetter@ffwll.ch, airlied@linux.ie, yongjun_wei@trendmicro.com.cn,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] drm/i915: fix error return code in
 init_pipe_control()
Message-ID: <20130528095943.GA15743@phenom.ffwll.local>
Mail-Followup-To: Wei Yongjun <weiyj.lk@gmail.com>, airlied@linux.ie,
	yongjun_wei@trendmicro.com.cn, intel-gfx@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <CAPgLHd_3SYA3UiZ0yAvNgAMv2jRiQXmEKibqTwJpsNF47EsX9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPgLHd_3SYA3UiZ0yAvNgAMv2jRiQXmEKibqTwJpsNF47EsX9g@mail.gmail.com>
X-Operating-System: Linux phenom 3.9.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 28, 2013 at 05:51:44PM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Fix to return -ENOMEM in the kmap() error handling case
> instead of 0, as done elsewhere in this function.
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Queued for -next, thanks for the patch.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
