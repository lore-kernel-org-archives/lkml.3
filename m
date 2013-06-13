Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759079Ab3FMTyY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:54:24 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:45411 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756060Ab3FMTyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:54:23 -0400
Date: Thu, 13 Jun 2013 12:54:21 -0700 (PDT)
Message-Id: <20130613.125421.1518137499194108848.davem@davemloft.net>
To: joe@perches.com
Cc: andy.shevchenko@gmail.com, Alexey.Brodkin@synopsys.com,
        netdev@vger.kernel.org, romieu@fr.zoreil.com,
        Vineet.Gupta1@synopsys.com, Mischa.Jonker@synopsys.com, arnd@arndb.de,
        grant.likely@linaro.org, rob.herring@calxeda.com,
        paul.gortmaker@windriver.com, linux-kernel@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v3] ethernet/arc/arc_emac - Add new driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1371148401.31941.20.camel@joe-AO722>
References: <1371134239-4531-1-git-send-email-abrodkin@synopsys.com>
	<CAHp75Vf4zjtebbaQMp4L0EmUPDVyrNPfvLODo7gHBuBEsWmZeA@mail.gmail.com>
	<1371148401.31941.20.camel@joe-AO722>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Joe Perches <joe@perches.com>
Date: Thu, 13 Jun 2013 11:33:21 -0700

> On Thu, 2013-06-13 at 21:25 +0300, Andy Shevchenko wrote:
>> On Thu, Jun 13, 2013 at 5:37 PM, Alexey Brodkin
>> > +               if (unlikely((info & OWN_MASK) == FOR_EMAC)) {
>> > +                       /* BD is still owned by EMAC */
>> > +                       continue;
>> > +               }
>> 
>> Redundant braces.
> 
> Maybe not.  Braces can be a visual aid when there is
> a comment in the test.

Agreed.
