Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534AbbA1D7K (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 22:59:10 -0500
Received: from mail-qa0-f42.google.com ([209.85.216.42]:47281 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484AbbA1D7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 22:59:07 -0500
Message-ID: <54C85E86.5010008@hurleysoftware.com>
Date: Tue, 27 Jan 2015 22:59:02 -0500
From: Peter Hurley <peter@hurleysoftware.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.4.0
MIME-Version: 1.0
To: Chunyan Zhang <chunyan.zhang@spreadtrum.com>, gregkh@linuxfoundation.org
CC: robh+dt@kernel.org, mark.rutland@arm.com, arnd@arndb.de,
        gnomes@lxorguk.ukuu.org.uk, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        grant.likely@linaro.org, jslaby@suse.cz, heiko@sntech.de,
        jason@lakedaemon.net, florian.vaussard@epfl.ch, andrew@lunn.ch,
        hytszk@gmail.com, antonynpavlov@gmail.com, shawn.guo@linaro.org,
        orsonzhai@gmail.com, geng.ren@spreadtrum.com,
        zhizhou.zhang@spreadtrum.com, lanqing.liu@spreadtrum.com,
        zhang.lyra@gmail.com, wei.qiao@spreadtrum.com,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org, linux-api@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 2/2] tty/serial: Add Spreadtrum sc9836-uart driver
 support
References: <sc9836-serial-v9> <1422413261-17184-1-git-send-email-chunyan.zhang@spreadtrum.com> <1422413261-17184-3-git-send-email-chunyan.zhang@spreadtrum.com>
In-Reply-To: <1422413261-17184-3-git-send-email-chunyan.zhang@spreadtrum.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/2015 09:47 PM, Chunyan Zhang wrote:
> Add a full sc9836-uart driver for SC9836 SoC which is based on the
> spreadtrum sharkl64 platform.
> This driver also support earlycon.

Reviewed-by: Peter Hurley <peter@hurleysoftware.com>


