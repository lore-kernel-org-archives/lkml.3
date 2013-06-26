Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751953Ab3FZIti (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 04:49:38 -0400
Received: from us02smtp1.synopsys.com ([198.182.60.75]:38178 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab3FZItf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 04:49:35 -0400
Message-ID: <51CAAB08.106@synopsys.com>
Date: Wed, 26 Jun 2013 14:19:12 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <Alexey.Brodkin@synopsys.com>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <andy.shevchenko@gmail.com>, <romieu@fr.zoreil.com>, <joe@perches.com>,
        <Vineet.Gupta1@synopsys.com>, <Mischa.Jonker@synopsys.com>,
        <arnd@arndb.de>, <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <paul.gortmaker@windriver.com>, <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <florian@openwrt.org>,
        <david.laight@aculab.com>
Subject: Re: [PATCH v8] ethernet/arc/arc_emac - Add new driver
References: <1372053267-19359-1-git-send-email-abrodkin@synopsys.com> <20130625.163452.653163641005496729.davem@davemloft.net>
In-Reply-To: <20130625.163452.653163641005496729.davem@davemloft.net>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.141]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/26/2013 05:04 AM, David Miller wrote:
> From: Alexey Brodkin <Alexey.Brodkin@synopsys.com>
> Date: Mon, 24 Jun 2013 09:54:27 +0400
>
>> Driver for non-standard on-chip ethernet device ARC EMAC 10/100,
>> instantiated in some legacy ARC (Synopsys) FPGA Boards such as
>> ARCAngel4/ML50x.
>>
>> Signed-off-by: Alexey Brodkin <abrodkin@synopsys.com>
> Applied to net-next, thanks.

Alexey, can you please send the DT updates for arch/arc to instantiate this as well

-Vineet
