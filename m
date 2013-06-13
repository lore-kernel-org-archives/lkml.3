Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758695Ab3FMTQv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 15:16:51 -0400
Received: from mail-oa0-f43.google.com ([209.85.219.43]:57826 "EHLO
	mail-oa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754694Ab3FMTQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 15:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <1371148401.31941.20.camel@joe-AO722>
References: <1371134239-4531-1-git-send-email-abrodkin@synopsys.com>
	<CAHp75Vf4zjtebbaQMp4L0EmUPDVyrNPfvLODo7gHBuBEsWmZeA@mail.gmail.com>
	<1371148401.31941.20.camel@joe-AO722>
Date: Thu, 13 Jun 2013 22:16:48 +0300
Message-ID: <CAHp75VdNpJ3x59+dV06rb29N=46W_GaDCc9EER3w8R6aSBZqnQ@mail.gmail.com>
Subject: Re: [PATCH v3] ethernet/arc/arc_emac - Add new driver
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Joe Perches <joe@perches.com>
Cc: Alexey Brodkin <Alexey.Brodkin@synopsys.com>,
        netdev <netdev@vger.kernel.org>,
        Francois Romieu <romieu@fr.zoreil.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>,
        Mischa Jonker <Mischa.Jonker@synopsys.com>,
        Arnd Bergmann <arnd@arndb.de>, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        "David S. Miller" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Devicetree Discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 13, 2013 at 9:33 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2013-06-13 at 21:25 +0300, Andy Shevchenko wrote:
>> On Thu, Jun 13, 2013 at 5:37 PM, Alexey Brodkin
>> <Alexey.Brodkin@synopsys.com> wrote:
>> > Driver for non-standard on-chip ethernet device ARC EMAC 10/100,
>> > instantiated in some legacy ARC (Synopsys) FPGA Boards such as
>> > ARCAngel4/ML50x.

>> > +++ b/drivers/net/ethernet/arc/arc_emac.h
> []
>> > +               if (unlikely((info & OWN_MASK) == FOR_EMAC)) {
>> > +                       /* BD is still owned by EMAC */
>> > +                       continue;
>> > +               }
>>
>> Redundant braces.
>
> Maybe not.  Braces can be a visual aid when there is
> a comment in the test.

I'm okay with both approaches. If author considers the comment is
useful in that form, I agree with him.

--
With Best Regards,
Andy Shevchenko
