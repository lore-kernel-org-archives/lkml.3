Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821AbaBJSik (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Feb 2014 13:38:40 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37664 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752740AbaBJSig (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Feb 2014 13:38:36 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Russell King <linux@arm.linux.org.uk>, Olof Johansson <olof@lixom.net>,
        Tony Lindgren <tony@atomide.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>
Subject: Re: [PATCH] ARM: multi_v7_defconfig: Select CONFIG_SOC_DRA7XX
References: <1391700571-31784-1-git-send-email-nm@ti.com>
Date: Mon, 10 Feb 2014 10:38:34 -0800
In-Reply-To: <1391700571-31784-1-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Thu, 6 Feb 2014 09:29:31 -0600")
Message-ID: <7hlhxi95jp.fsf@paris.lan>
User-Agent: Gnus/5.130008 (Ma Gnus v0.8) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> Select CONFIG_SOC_DRA7XX so that we can boot dra7-evm.
> DRA7 family are A15 based processors that supports LPAE and an
> evolutionary update to the OMAP5 generation of processors.
>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> ---
>
> based on v3.13-rc1 kernel tag - tested on v3.14-rc1 and next-20140206

Applied to arm-soc/fixes for v3.14-rc.

Kevin
