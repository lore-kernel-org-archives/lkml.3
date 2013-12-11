Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752051Ab3LKPQF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 10:16:05 -0500
Received: from mail-ie0-f169.google.com ([209.85.223.169]:41629 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab3LKPQC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 10:16:02 -0500
Date: Wed, 11 Dec 2013 10:15:56 -0500
From: Matt Porter <matt.porter@linaro.org>
To: Kamil Debski <k.debski@samsung.com>
Cc: linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org,
        kyungmin.park@samsung.com, kishon@ti.com, t.figa@samsung.com,
        s.nawrocki@samsung.com, m.szyprowski@samsung.com,
        gautam.vivek@samsung.com, mat.krawczuk@gmail.com,
        yulgon.kim@samsung.com, p.paneri@samsung.com,
        av.tikhomirov@samsung.com, jg1.han@samsung.com, galak@codeaurora.org
Subject: Re: [PATCH v4 5/9] usb: s3c-hsotg: Use the new Exynos USB phy driver
 with the generic phy framework
Message-ID: <20131211151556.GB6279@beef>
References: <1386246579-25141-1-git-send-email-k.debski@samsung.com>
 <1386246579-25141-6-git-send-email-k.debski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386246579-25141-6-git-send-email-k.debski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 05, 2013 at 01:29:35PM +0100, Kamil Debski wrote:
> Change the used phy driver to the new Exynos USB phy driver that uses the
> generic phy framework.
> 
> Signed-off-by: Kamil Debski <k.debski@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  .../devicetree/bindings/usb/samsung-hsotg.txt      |    4 ++++
>  drivers/usb/gadget/s3c-hsotg.c                     |   11 ++++++-----
>  2 files changed, 10 insertions(+), 5 deletions(-)

This is only applying with fuzz against -rc3, needs an update. It's
otherwise still working fine on my BCM Capri board.

-Matt
