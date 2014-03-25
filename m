Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753301AbaCYNSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Mar 2014 09:18:13 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46360 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751624AbaCYNSL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Mar 2014 09:18:11 -0400
Message-ID: <533181ED.6040702@ti.com>
Date: Tue, 25 Mar 2014 09:17:33 -0400
From: Santosh Shilimkar <santosh.shilimkar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: "Balbi, Felipe" <balbi@ti.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>, Jason Cooper <jason@lakedaemon.net>
Subject: Re: linux-next: manual merge of the keystone tree with the arm-soc
 tree
References: <20140325105501.e63fcdd78d0d604b4e5309a1@canb.auug.org.au> <5330C703.5030705@ti.com> <20140325012353.GA25643@saruman.home>
In-Reply-To: <20140325012353.GA25643@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 March 2014 09:23 PM, Balbi, Felipe wrote:
> On Mon, Mar 24, 2014 at 08:00:03PM -0400, Santosh Shilimkar wrote:
>> On Monday 24 March 2014 07:55 PM, Stephen Rothwell wrote:
>>> Hi Santosh,
>>>
>>> Today's linux-next merge of the keystone tree got a conflict in
>>> arch/arm/boot/dts/Makefile between commit ba5a37e52194 ("ARM: mvebu: Move
>>> kirkwood DT boards into mach-mvebu") from the arm-soc tree and commit
>>> 400550ae7e77 ("ARM: dts: Build all keystone dt blobs") from the keystone
>>> tree.
>>>
>>> I fixed it up (see below) and can carry the fix as necessary (no action
>>> is required).
>>>
>> Looks fine. Thanks
> 
> wow, not even a mention of my original patch [1]. I also couldn't find
> your patch [2] anywhere in the mailing list archives, not even google
> could find it. The only place that commit was ever mentioned was this
> very thread.
> 
I thought, we closed the thread mentioning about the patch applied
on the same thread. [1]

> The patch I wrote was valid for v3.14-rc7 (the base where it was
> written), I'd expect to, at a minimum, have a mention or a Reported-by
> or at least see your patch in the mailing list.
> 
> Anyway, it's just a patch. Nevermind.
> 
I missed to add the reported-by tag and also should have just pasted
the patch in the reply. Sorry about that.

regards,
Santosh

[1] http://www.spinics.net/lists/devicetree/msg27351.html
