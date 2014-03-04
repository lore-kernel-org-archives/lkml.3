Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756958AbaCDLYR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 06:24:17 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:59146 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756845AbaCDLYO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 06:24:14 -0500
Message-ID: <5315B7D2.3060104@ti.com>
Date: Tue, 4 Mar 2014 13:24:02 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <dmitry.torokhov@gmail.com>
CC: <rydberg@euromail.se>, <jcbian@pixcir.com.cn>, <balbi@ti.com>,
        <dmurphy@ti.com>, <mugunthanvnm@ti.com>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>
Subject: Re: [PATCH v2 0/8] Input: pixcir_i2c_ts: Add Type-B Multi-touch and
 DT support
References: <1393428486-15001-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1393428486-15001-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

Gentle reminder to comment on this series. Thanks.

cheers,
-roger

On 02/26/2014 05:27 PM, Roger Quadros wrote:
> Hi,
> 
> This series does the following
> 
> - use devres managed resource allocations
> - convert to Type-B multi touch protocol
> - support upto 5 fingers with hardware supplied tracking IDs
> - device tree support
> 
> Changelog:
> 
> v2:
> - Addressed review comments and re-arranged patch order
> 
> v1:
> - http://article.gmane.org/gmane.linux.kernel/1616417
> 
> cheers,
> -roger
> 
> ---
> Roger Quadros (8):
>   Input: pixcir_i2c_ts: Use devres managed resource allocations
>   Input: pixcir_i2c_ts: Initialize interrupt mode and power mode
>   Input: pixcir_i2c_ts: Get rid of pdata->attb_read_val()
>   Input: pixcir_i2c_ts: Use Type-B Multi-Touch protocol
>   Input: pixcir_i2c_ts: support upto 5 fingers and hardware provided
>     tracking IDs
>   Input: pixcir_i2c_ts: Implement wakeup from suspend
>   Input: pixcir_i2c_ts: Add device tree support
>   ARM: dts: am43x-epos-evm: Correct Touch controller info
> 
>  .../bindings/input/touchscreen/pixcir_i2c_ts.txt   |  26 ++
>  .../devicetree/bindings/vendor-prefixes.txt        |   1 +
>  arch/arm/boot/dts/am43x-epos-evm.dts               |  13 +-
>  drivers/input/touchscreen/pixcir_i2c_ts.c          | 510 ++++++++++++++++++---
>  include/linux/input/pixcir_ts.h                    |  56 ++-
>  5 files changed, 545 insertions(+), 61 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/input/touchscreen/pixcir_i2c_ts.txt
> 

