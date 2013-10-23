Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab3JWIhD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Oct 2013 04:37:03 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:54951 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751983Ab3JWIhA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Oct 2013 04:37:00 -0400
Message-ID: <52678AA8.1040105@baylibre.com>
Date: Wed, 23 Oct 2013 10:36:56 +0200
From: Benoit Cousson <bcousson@baylibre.com>
Organization: BayLibre
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Sebastian Reichel <sre@debian.org>, Tony Lindgren <tony@atomide.com>
CC: linux-omap@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/14] DTS: ARM: OMAP3-N900: Add misc. HW
References: <1382482183-14426-1-git-send-email-sre@debian.org>
In-Reply-To: <1382482183-14426-1-git-send-email-sre@debian.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sebastian,

On 23/10/2013 00:49, Sebastian Reichel wrote:
> This patchset adds misc. hardware elements to the Nokia N900 DTS
> file. Apart from the last two patches the kernel drivers in 3.12
> are already capable of handling the DT entries.
>
> The series is based on bcousson/linux-omap-dt.git:for_3.13/dts.

Thanks, I've just applied the whole series.

Regards,
Benoit

-- 
Benoît Cousson
BayLibre
Embedded Linux Technology Lab
www.baylibre.com
