Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbaENNVB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 09:21:01 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:43502 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357AbaENNU7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 09:20:59 -0400
Message-ID: <53736DA1.4040405@ti.com>
Date: Wed, 14 May 2014 16:20:33 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Kishon Vijay Abraham I <kishon@ti.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-omap@vger.kernel.org>,
        <linux-pci@vger.kernel.org>
CC: <balajitk@ti.com>
Subject: Re: [PATCH 04/17] phy: pipe3: insert delay to enumerate in GEN2 mode
References: <1399383244-14556-1-git-send-email-kishon@ti.com> <1399383244-14556-5-git-send-email-kishon@ti.com>
In-Reply-To: <1399383244-14556-5-git-send-email-kishon@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2014 04:33 PM, Kishon Vijay Abraham I wrote:
> 8-bit delay value (0xF1) is required for GEN2 devices to be enumerated
> consistently. Added an API to be called from PHY drivers to set this delay
> value and called it from PIPE3 driver to set the delay value.
> 
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

Reviewed-by: Roger Quadros <rogerq@ti.com>

--
cheers,
-roger

