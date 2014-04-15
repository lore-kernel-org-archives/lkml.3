Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199AbaDOBpT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 21:45:19 -0400
Received: from g4t3427.houston.hp.com ([15.201.208.55]:18767 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984AbaDOBpS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 21:45:18 -0400
Message-ID: <534C8EFF.1030804@hp.com>
Date: Tue, 15 Apr 2014 09:44:31 +0800
From: "Li, ZhenHua" <zhen-hual@hp.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: kas@fi.muni.cz, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] driver/net: remove unused code in cosa module
References: <1397470116-19669-1-git-send-email-zhen-hual@hp.com> <20140414.133100.2108506432746999980.davem@davemloft.net>
In-Reply-To: <20140414.133100.2108506432746999980.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for your correction. I will send again with proper reason.

On 04/15/2014 01:31 AM, David Miller wrote:
> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
> Date: Mon, 14 Apr 2014 18:08:36 +0800
>
>> For the cosa module, CONFIG_COSA can only be checked as 'm',
>> and cosa module can only be compiled as a module.
> That's not true, it's "tristate" in drivers/net/wan/Kconfig so it
> could be set to 'y' too.
>
> But there is another reason to make this change, because for such
> large timeout values only msleep() makes sense, udelay() could
> overflow it's internal precision.
>
> Please resubmit this with the proper reasoning and commit message.

