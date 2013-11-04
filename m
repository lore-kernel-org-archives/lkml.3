Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab3KDInX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 03:43:23 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:61403 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab3KDInV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 03:43:21 -0500
MIME-Version: 1.0
In-Reply-To: <5273D9CD.2010800@gmail.com>
References: <1383076268-8984-1-git-send-email-s.nawrocki@samsung.com>
	<CACmBeS2TiiTJ_n0bEzXGKN8B=U9EKXeVtrE2q0jgxsxf5TBivw@mail.gmail.com>
	<5273D9CD.2010800@gmail.com>
Date: Mon, 4 Nov 2013 09:43:20 +0100
Message-ID: <CACmBeS3DhHnQR7Ze8oZVAC9HThmXR4n7f90yje+R=8uRq9Nvsg@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] clk: clock deregistration support
From: Jonas Jensen <jonas.jensen@gmail.com>
To: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Cc: Sylwester Nawrocki <s.nawrocki@samsung.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Mike Turquette <mturquette@linaro.org>, linux-mips@linux-mips.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-sh@vger.kernel.org, jiada_wang@mentor.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        laurent.pinchart@ideasonboard.com,
        uclinux-dist-devel@blackfin.uclinux.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1 November 2013 17:41, Sylwester Nawrocki
<sylvester.nawrocki@gmail.com> wrote:
> It is recommended to quote also human readable patch summary line,
> so it's more immediately clear which patch you refer to.

Sorry about that. This was tested on a clean (some added moxart
drivers but no other patches) next-20131031, reverting the following
patch:
"clkdev: Fix race condition in clock lookup from device tree" -
0b35b92fb3600a2f9ca114a6142db95f760d55f5

> Is the warning still triggered when you apply this patch:
> http://www.spinics.net/lists/arm-kernel/msg283550.html
> onto next-20131031 instead of reverting ?

After patch, the warning is no longer triggered.

Thanks,
Jonas
