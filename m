Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbaHFRPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2014 13:15:52 -0400
Received: from casper.infradead.org ([85.118.1.10]:43506 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756446AbaHFRPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2014 13:15:49 -0400
Message-ID: <53E262BF.7040509@infradead.org>
Date: Wed, 06 Aug 2014 10:15:43 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org
CC: linux-kernel@vger.kernel.org, Philipp Zabel <p.zabel@pengutronix.de>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Sugar <shuge@allwinnertech.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>
Subject: Re: linux-next: Tree for Aug 6 (sun6i-dma.c)
References: <20140806172857.44a2a900@canb.auug.org.au> <53E25AFF.6030409@infradead.org>
In-Reply-To: <53E25AFF.6030409@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/06/14 09:42, Randy Dunlap wrote:
> On 08/06/14 00:28, Stephen Rothwell wrote:
>> Hi all,
>>
>> Please do not add code intended for v3.18 until after v3.17-rc1 is
>> released.
>>
>> Changes since 20140805:
>>
> 
> on x86_64:
> when CONFIG_RESET_CONTROLLER is not enabled:
> 
> ../drivers/dma/sun6i-dma.c: In function 'sun6i_dma_probe':
> ../drivers/dma/sun6i-dma.c:911:2: error: implicit declaration of function 'devm_reset_control_get' [-Werror=implicit-function-declaration]
> 
> 
> Add a stub for that function?
> 

or that driver's Kconfig entry could select RESET_CONTROLLER.


-- 
~Randy
