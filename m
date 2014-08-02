Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754881AbaHBNSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Aug 2014 09:18:16 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:33959 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255AbaHBNSO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Aug 2014 09:18:14 -0400
Message-ID: <53DCE511.3070404@gmail.com>
Date: Sat, 02 Aug 2014 15:18:09 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
CC: linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        Stephan van Schaik <stephan@synkhronix.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Tomasz Figa <t.figa@samsung.com>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v6 10/10] ARM: dts: Add exynos5250-spring device tree
References: <1406940750-15880-1-git-send-email-afaerber@suse.de> <1406940750-15880-11-git-send-email-afaerber@suse.de>
In-Reply-To: <1406940750-15880-11-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02.08.2014 02:52, Andreas Färber wrote:
> Adds initial support for the HP Chromebook 11.
> 
> Cc: Vincent Palatin <vpalatin@chromium.org>
> Cc: Doug Anderson <dianders@chromium.org>
> Cc: Stephan van Schaik <stephan@synkhronix.com>
> Signed-off-by: Andreas Färber <afaerber@suse.de>
> ---
>  v5 -> v6:
>  * Updated for mfc node label
>  * Reverted to dp-hpd-gpio node in pinctrl_0 (Doug Anderson)
>  * Fixed alphabetical order of sd1_* nodes (Doug Anderson)
>  

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
