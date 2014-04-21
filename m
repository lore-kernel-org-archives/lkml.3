Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827AbaDUMzv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 08:55:51 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38075 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751134AbaDUMzt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 08:55:49 -0400
Date: Mon, 21 Apr 2014 13:55:45 +0100
From: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, myungjoo.ham@samsung.com, balbi@ti.com,
        gg@slimlogic.co.uk, kishon@ti.com, broonie@kernel.org,
        k.kozlowski@samsung.com, kyungmin.park@samsung.com,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCHv2 7/9] extcon: arizona: Use devm_extcon_dev_allocate
	for extcon_dev
Message-ID: <20140421125545.GA25663@opensource.wolfsonmicro.com>
References: <1398081742-24277-1-git-send-email-cw00.choi@samsung.com> <1398081742-24277-8-git-send-email-cw00.choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1398081742-24277-8-git-send-email-cw00.choi@samsung.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 09:02:20PM +0900, Chanwoo Choi wrote:
> This patch use devm_extcon_dev_allocate() to simplify the memory control
> of extcon device.
> 
> Cc: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: patches@opensource.wolfsonmicro.com
> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> ---

Acked-by: Charles Keepax <ckeepax@opensource.wolfsonmicro.com>

Thanks,
Charles
