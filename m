Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab3EVTwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:52:46 -0400
Received: from mail-ea0-f180.google.com ([209.85.215.180]:34193 "EHLO
	mail-ea0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756505Ab3EVTwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:52:45 -0400
Message-ID: <519D2208.8040902@gmail.com>
Date: Wed, 22 May 2013 21:52:40 +0200
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
References: <1369154510-4927-7-git-send-email-sebastian.hesselbarth@gmail.com> <20130521174849.GL26249@lunn.ch> <519C9333.20609@gmail.com> <519C9822.9040909@windriver.com> <519C9A66.3050807@gmail.com> <20130522131010.GB31290@titan.lakedaemon.net> <20130522165908.GB12320@obsidianresearch.com> <519D0143.1000203@gmail.com> <20130522173505.GH31290@titan.lakedaemon.net> <519D038C.9000605@gmail.com> <20130522174815.GI31290@titan.lakedaemon.net>
In-Reply-To: <20130522174815.GI31290@titan.lakedaemon.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2013 07:48 PM, Jason Cooper wrote:
> On Wed, May 22, 2013 at 07:42:36PM +0200, Sebastian Hesselbarth wrote:
>> On 05/22/2013 07:35 PM, Jason Cooper wrote:
>>> On Wed, May 22, 2013 at 07:32:51PM +0200, Sebastian Hesselbarth wrote:
>>>> Just tested on Dockstar with gated clocks and modular DT mv643xx_eth.
>>>>
>>>> Will append to the DT mv643xx_eth patch set if a v5 will be required
>>>> or as single patch prior Jason C taking in the ARM part of it
>>>> otherwise.
>>>
>>> Please post, in-reply-to v4 is fine.
>>
>> Hmm, maybe a little bit too early. While restoring the MAC address now
>> works, another bug arises which I guess is related with phy setup
>> and aneg.
>>
>> Will investigate and update patch set accordingly.

Ok, have it working now by properly clearing CLK125_BYPASS_EN bit in
PORT_SERIAL_CTRL1 register for Kirkwood only. I have two more patches
ready that I will post as single patches in reply to v4.

If David gives his ACK for the patch set and names a branch to base it
on, I will send a v5 including all patches.

Sebastian
