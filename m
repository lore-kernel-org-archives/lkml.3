Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754674AbaGNLeY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 07:34:24 -0400
Received: from mail-ie0-f178.google.com ([209.85.223.178]:60073 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680AbaGNLeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 07:34:19 -0400
Date: Mon, 14 Jul 2014 12:34:13 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: linux-kernel@vger.kernel.org, sergei.shtylyov@cogentembedded.com,
        antoine.tenart@free-electrons.com, gregkh@linuxfoundation.org
Subject: Re: [PATCH 2/2] phy: core: Let node ptr of PHY point to PHY and not
 of PHY provider
Message-ID: <20140714113413.GN2954@lee--X1>
References: <1405333502-24385-1-git-send-email-kishon@ti.com>
 <1405333502-24385-2-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1405333502-24385-2-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Jul 2014, Kishon Vijay Abraham I wrote:

> In case of multi-phy PHY providers, each PHY should be modeled as a sub
> node of the PHY provider. Then each PHY will have a different node pointer
> (node pointer of sub node) than that of PHY provider. Added this provision
> in the PHY core.
> Also fixed all drivers to use the updated API.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Same here.  Patch looks good though.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
