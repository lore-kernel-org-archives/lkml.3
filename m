Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753598Ab3GAORk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 10:17:40 -0400
Received: from mail-la0-f50.google.com ([209.85.215.50]:65525 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3GAORj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:17:39 -0400
MIME-Version: 1.0
X-Originating-IP: [93.173.177.224]
In-Reply-To: <1370034976-29599-1-git-send-email-s-anna@ti.com>
References: <1370034976-29599-1-git-send-email-s-anna@ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 1 Jul 2013 17:17:18 +0300
Message-ID: <CAK=WgbYxJX7fZLo-XqwOQDr_P00hkZ_EprpVVKXHqAmY+L+GoA@mail.gmail.com>
Subject: Re: [PATCH 2/3] remoteproc/omap: fix a sparse warning
To: Suman Anna <s-anna@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 1, 2013 at 12:16 AM, Suman Anna <s-anna@ti.com> wrote:
> This patch fixes a sparse warning in the omap remoteproc code
> when OMAP_REMOTEPROC is disabled.
>
> include/linux/platform_data/remoteproc-omap.h:76:13: warning: symbol 'omap_rproc_reserve_cma' was not declared. Should it be static?
>
> Signed-off-by: Suman Anna <s-anna@ti.com>

Applied, thanks
