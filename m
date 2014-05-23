Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831AbaEWTeG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 15:34:06 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:58594 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaEWTeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 15:34:03 -0400
Message-ID: <537FA2A9.6050309@codeaurora.org>
Date: Fri, 23 May 2014 12:34:01 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, netdev@vger.kernel.org,
        robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        devicetree@vger.kernel.org, nm@ti.com
Subject: Re: [PATCH 0/5] ks8851 DT updates
References: <1400792413-21618-1-git-send-email-sboyd@codeaurora.org> <20140523.151502.1106354754894891974.davem@davemloft.net>
In-Reply-To: <20140523.151502.1106354754894891974.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/14 12:15, David Miller wrote:
> From: Stephen Boyd <sboyd@codeaurora.org>
> Date: Thu, 22 May 2014 14:00:08 -0700
>
>> This set of patches properly documents the micrel ks8851 spi ethernet
>> controller, converts to devm_regulator_get_optional() to make error
>> paths slightly simpler, and finally adds supports for another
>> optional regulator and a reset gpio.
> Please do not submit patch sets that you expect different trees to
> integrate, this is painful for maintainers to deal with.
>
> Instead, submit the changes separately.  One series for one
> maintainer's tree, another for the other maintainer's tree.
>

Ok. Shall I resend this series with the proper separation? Or can you
ignore the first patch? There isn't any functional dependency, more just
a checkpatch dependency which is not really all that important.

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

