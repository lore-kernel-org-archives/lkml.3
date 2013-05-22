Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756957Ab3EVSzJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 14:55:09 -0400
Received: from mail-ea0-f173.google.com ([209.85.215.173]:39299 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652Ab3EVSzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 14:55:06 -0400
Message-ID: <519D1485.50801@gmail.com>
Date: Wed, 22 May 2013 20:55:01 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Jason Cooper <jason@lakedaemon.net>
CC: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>,
        "tiejun.chen" <tiejun.chen@windriver.com>,
        Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, David Miller <davem@davemloft.net>,
        Lennert Buytenhek <buytenh@wantstofly.org>
Subject: Re: [PATCH v4 06/12] ARM: dove: add gigabit ethernet and mvmdio device
 tree nodes
References: <519C9333.20609@gmail.com> <519C9822.9040909@windriver.com> <519C9A66.3050807@gmail.com> <20130522131010.GB31290@titan.lakedaemon.net> <20130522165908.GB12320@obsidianresearch.com> <519D0143.1000203@gmail.com> <20130522173505.GH31290@titan.lakedaemon.net> <519D038C.9000605@gmail.com> <20130522174815.GI31290@titan.lakedaemon.net> <519D1204.4090701@gmail.com> <20130522184936.GK31290@titan.lakedaemon.net>
In-Reply-To: <20130522184936.GK31290@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 08:49 PM, Jason Cooper wrote:
> On Wed, May 22, 2013 at 08:44:20PM +0200, Sebastian Hesselbarth wrote:
>> On 05/22/2013 07:48 PM, Jason Cooper wrote:
>>> On Wed, May 22, 2013 at 07:42:36PM +0200, Sebastian Hesselbarth wrote:
>>>> Hmm, maybe a little bit too early. While restoring the MAC address now
>>>> works, another bug arises which I guess is related with phy setup
>>>> and aneg.
>>>>
>>>> Will investigate and update patch set accordingly.
>>>
>>> Cool, chances are, we should be able to take that patch in by itself for
>>> this merge window...
>>
>> Which patch do you mean? The local-mac-address workaround will only be
>> available for DT mv643xx_eth because it uses the DT node to store the
>> MAC.
>
> I thought you were replacing the unconditional ethernet clock grabbing
> with reading the mac from the registers and updating the dtb?  In
> mach-kirkwood/board-dt.c?

True. But there is no node for ethernet controllers in kirkwood.dtsi
yet. It will be there with mv643xx_eth DT patches applied and that is
when the corresponding replacement patch should also be taken in.

I was just confused about your referral to the merge window, because I
guess it is up to David Miller to decide when/whether to take
mv643xx_eth patches in.

Sebastian

