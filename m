Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaGaTWU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2014 15:22:20 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:50890 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646AbaGaTWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2014 15:22:18 -0400
Message-ID: <53DA9763.2070709@gmail.com>
Date: Thu, 31 Jul 2014 21:22:11 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: =?UTF-8?B?QW5kcmVhcyBGw6RyYmVy?= <afaerber@suse.de>,
        linux-samsung-soc@vger.kernel.org
CC: Mark Rutland <mark.rutland@arm.com>, devicetree@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Pawel Moll <pawel.moll@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        open list <linux-kernel@vger.kernel.org>,
        Kumar Gala <galak@codeaurora.org>,
        Stephan van Schaik <stephan@synkhronix.com>,
        Doug Anderson <dianders@chromium.org>,
        Rob Herring <robh+dt@kernel.org>, Ben Dooks <ben-linux@fluff.org>,
        Russell King <linux@arm.linux.org.uk>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v4 2/4] ARM: dts: Fold exynos5250-cros-common into exynos5250-snow
References: <1406822910-6255-1-git-send-email-afaerber@suse.de> <1406822910-6255-3-git-send-email-afaerber@suse.de>
In-Reply-To: <1406822910-6255-3-git-send-email-afaerber@suse.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Please see my comments inline.

On 31.07.2014 18:08, Andreas Färber wrote:
> The remaining common ChromeOS pieces are fairly minor.
> 

For people that might stumble upon this patch in future, it would be
nice to specify the reason for this change.

Otherwise feel free to add:

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz
