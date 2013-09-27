Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab3I0IMO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 04:12:14 -0400
Received: from mail-wi0-f175.google.com ([209.85.212.175]:55983 "EHLO
	mail-wi0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab3I0IME (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 04:12:04 -0400
Date: Fri, 27 Sep 2013 09:11:55 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Andrzej Hajda <a.hajda@samsung.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 2/2] max77693: added device tree support
Message-ID: <20130927081155.GA9048@lee--X1>
References: <20130927071744.GA5100@lee--X1>
 <1380266866-32103-1-git-send-email-a.hajda@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1380266866-32103-1-git-send-email-a.hajda@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 27 Sep 2013, Andrzej Hajda wrote:

> This patch adds only of_match_table.
> There are no device specific properties.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
> Hi,
> 
> Spaces added.
> 
> Regards
> Andrzej
> ---
>  drivers/mfd/max77693.c | 8 ++++++++
>  1 file changed, 8 insertions(+)

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
