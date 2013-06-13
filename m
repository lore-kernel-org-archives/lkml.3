Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758999Ab3FMTnA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:43:00 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:49035 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3FMTm6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:42:58 -0400
Date: Thu, 13 Jun 2013 21:42:31 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        netdev <netdev@vger.kernel.org>, Joe Perches <joe@perches.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v3] ethernet/arc/arc_emac - Add new driver
Message-ID: <20130613194231.GA11949@electric-eye.fr.zoreil.com>
References: <1371134239-4531-1-git-send-email-abrodkin@synopsys.com>
 <CAHp75Vf4zjtebbaQMp4L0EmUPDVyrNPfvLODo7gHBuBEsWmZeA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHp75Vf4zjtebbaQMp4L0EmUPDVyrNPfvLODo7gHBuBEsWmZeA@mail.gmail.com>
X-Organisation: Land of Sunshine Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko <andy.shevchenko@gmail.com> :
[...]
> I just realize you are using circular buffer here. What about to use
> them with linux' native framework? Documentation/circular-buffers.txt

It's almost unused in drivers/net. I won't mind if it stays this way.

-- 
Ueimor
