Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756311Ab3APR5g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:57:36 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:57188 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755732Ab3APR5d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 12:57:33 -0500
Message-ID: <50F6EA0A.4080904@wwwdotorg.org>
Date: Wed, 16 Jan 2013 10:57:30 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: linux@arm.linux.org.uk, linux-tegra@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ARM: tegra: config: enable SERIAL_TEGRA
References: <1358341572-8154-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1358341572-8154-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/16/2013 06:06 AM, Laxman Dewangan wrote:
> Enable high speed serial driver for tegra platform.

Thanks, I've applied patch 1 to Tegra's for-3.9/defconfig branch and
patch 2 to Tegra's for-3.9/dt branch.

Just as an FYI, the dt branch is merged into my for-next branch, and
sent upstream, before the defconfig branch, so your patch order was
reversed relative to that, but it's not an issue here.

Question: How do I test this; do I just fire up bluez(?) and point it at
the UARTC serial port, or is there more to it?
