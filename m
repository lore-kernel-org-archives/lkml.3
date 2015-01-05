Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753308AbbAEIyb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jan 2015 03:54:31 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:56719 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbbAEIy3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jan 2015 03:54:29 -0500
Date: Mon, 5 Jan 2015 09:54:24 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Liu Ying <Ying.Liu@freescale.com>
Cc: dri-devel@lists.freedesktop.org, stefan.wahren@i2se.com,
        devicetree@vger.kernel.org, linux@arm.linux.org.uk,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        a.hajda@samsung.com, mturquette@linaro.org,
        linux-arm-kernel@lists.infradead.org, andyshrk@gmail.com
Subject: Re: [PATCH RFC v7 16/21] drm: panel: Add support for Himax HX8369A
 MIPI DSI panel
Message-ID: <20150105085424.GP2711@phenom.ffwll.local>
Mail-Followup-To: Liu Ying <Ying.Liu@freescale.com>,
	dri-devel@lists.freedesktop.org, stefan.wahren@i2se.com,
	devicetree@vger.kernel.org, linux@arm.linux.org.uk,
	kernel@pengutronix.de, linux-kernel@vger.kernel.org,
	a.hajda@samsung.com, mturquette@linaro.org,
	linux-arm-kernel@lists.infradead.org, andyshrk@gmail.com
References: <1419910451-15268-1-git-send-email-Ying.Liu@freescale.com>
 <1419910451-15268-17-git-send-email-Ying.Liu@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419910451-15268-17-git-send-email-Ying.Liu@freescale.com>
X-Operating-System: Linux phenom 3.16-2-amd64 
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 30, 2014 at 11:34:06AM +0800, Liu Ying wrote:
> This patch adds support for Himax HX8369A MIPI DSI panel.
> 
> Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Liu Ying <Ying.Liu@freescale.com>
> ---
> v6->v7:
>  * Address Andrzej Hajda's following comments.
>  * Simplify the return logic in hx8369a_dcs_write().
>  * Replace the macro hx8369a_dsi_init_helper() with a function array to improve
>    the code quality.
>  * Handle error cases during getting gpios in probe().
>  * Add 'Reviewed-by: Andrzej Hajda <a.hajda@samsung.com>'.

If you only update one patch in a big series it's imo better to just
resend that one to avoid spamming the mailing list with noise. Imo it also
helps to keep the discussion all nicely grouped together.

In any case please give a short overview of what changed in the cover
letter when resending the entire series so that people don't have to go
through all the invidual patches.
-Daniel
-- 
Daniel Vetter
Software Engineer, Intel Corporation
+41 (0) 79 365 57 48 - http://blog.ffwll.ch
