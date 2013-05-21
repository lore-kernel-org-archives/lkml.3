Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab3EUGQT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 May 2013 02:16:19 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:50561 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755848Ab3EUGQQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 May 2013 02:16:16 -0400
Message-ID: <519B1135.4060509@prisktech.co.nz>
Date: Tue, 21 May 2013 18:16:21 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Tony Prisk <linux@prisktech.co.nz>
CC: Wolfram Sang <wsa@the-dreams.de>, linux-arm-kernel@lists.infradead.org,
        vt8500-wm8505-linux-kernel@googlegroups.com,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org
Subject: Re: [PATCH] i2c: vt8500: Add support for I2C bus on Wondermedia SoCs
References: <1368350634-12654-1-git-send-email-linux@prisktech.co.nz>
In-Reply-To: <1368350634-12654-1-git-send-email-linux@prisktech.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/13 21:23, Tony Prisk wrote:
> This patch adds support for the I2C bus controllers found on Wondermedia
> 8xxx-series SoCs. Only master-mode is supported.
>
> Signed-off-by: Tony Prisk <linux@prisktech.co.nz>
> ---
>   .../devicetree/bindings/i2c/i2c-vt8500.txt         |   24 +
>   MAINTAINERS                                        |    1 +
>   drivers/i2c/busses/Kconfig                         |   10 +
>   drivers/i2c/busses/Makefile                        |    1 +
>   drivers/i2c/busses/i2c-wmt.c                       |  488 ++++++++++++++++++++
>   5 files changed, 524 insertions(+)
>   create mode 100644 Documentation/devicetree/bindings/i2c/i2c-vt8500.txt
>   create mode 100644 drivers/i2c/busses/i2c-wmt.c
>
>
This patch seems to have stalled. Any news?

Regards
Tony Prisk
