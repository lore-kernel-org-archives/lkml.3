Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab3AQJZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 04:25:00 -0500
Received: from mail-ie0-f171.google.com ([209.85.223.171]:64157 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755997Ab3AQJY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 04:24:57 -0500
MIME-Version: 1.0
In-Reply-To: <1358391258-1771-26-git-send-email-keescook@chromium.org>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
	<1358391258-1771-26-git-send-email-keescook@chromium.org>
Date: Thu, 17 Jan 2013 10:24:56 +0100
Message-ID: <CAHTX3dKAdrnDQLBhA-vEiQP+BHHaHJ55AsCB642TrdeFCA1h3g@mail.gmail.com>
Subject: Re: [PATCH 25/86] arch/microblaze/platform: remove depends on CONFIG_EXPERIMENTAL
From: Michal Simek <monstr@monstr.eu>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/1/17 Kees Cook <keescook@chromium.org>:
> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during the
> Linux kernel summit, remove it from any "depends on" lines in Kconfigs.
>
> CC: Michal Simek <monstr@monstr.eu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

Acked-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel - Microblaze cpu - http://www.monstr.eu/fdt/
Maintainer of Linux kernel - Xilinx Zynq ARM architecture
Microblaze U-BOOT custodian
