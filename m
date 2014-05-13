Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759754AbaEMLfm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 07:35:42 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36556 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759367AbaEMLfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 07:35:41 -0400
Date: Tue, 13 May 2014 12:35:37 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org, patches@opensource.wolfsonmicro.com,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH 08/16] mfd: wm8400-core: Make mfd_cell array const
Message-ID: <20140513113537.GK25203@opensource.wolfsonmicro.com>
References: <1399978733-13662-1-git-send-email-k.kozlowski@samsung.com> <1399978733-13662-8-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1399978733-13662-8-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 12:58:45PM +0200, Krzysztof Kozlowski wrote:
> mfd_add_devices() expects array of struct mfd_cell to be const.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: Mark Brown <broonie@linaro.org>
> Cc: patches@opensource.wolfsonmicro.com
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
