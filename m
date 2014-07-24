Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758529AbaGXLVE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 07:21:04 -0400
Received: from mail-ig0-f172.google.com ([209.85.213.172]:40791 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754985AbaGXLVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 07:21:02 -0400
Date: Thu, 24 Jul 2014 12:20:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Peter Griffin <peter.griffin@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        maxime.coquelin@st.com, patrice.chotard@st.com,
        gregkh@linuxfoundation.org, srinivas.kandagatla@gmail.com,
        linux-usb@vger.kernel.org, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 1/3] usb: host: st-hcd: Add USB HCD support for STi
 SoCs
Message-ID: <20140724112055.GC7063@lee--X1>
References: <1406199616-10533-1-git-send-email-peter.griffin@linaro.org>
 <1406199616-10533-2-git-send-email-peter.griffin@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1406199616-10533-2-git-send-email-peter.griffin@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jul 2014, Peter Griffin wrote:

> This driver adds support for the USB HCD present in STi
> SoC's from STMicroelectronics. It has been tested on the
> stih416-b2020 board.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
>  drivers/usb/host/Kconfig  |  12 ++
>  drivers/usb/host/Makefile |   1 +
>  drivers/usb/host/st-hcd.c | 460 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 473 insertions(+)
>  create mode 100644 drivers/usb/host/st-hcd.c

Looks good to me now:

Acked-by: Lee Jones <lee.jones@linaro.org>

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
