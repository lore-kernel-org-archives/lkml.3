Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885AbaGBFeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 01:34:08 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:46740 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754804AbaGBFeE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 01:34:04 -0400
From: "Gupta, Pekon" <pekon@ti.com>
To: =?iso-8859-1?Q?Ezequiel_Garc=EDa?= <ezequiel@vanguardiasur.com.ar>,
        =?iso-8859-1?Q?Guido_Mart=EDnez?= <guido@vanguardiasur.com.ar>
CC: Tony Lindgren <tony@atomide.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH] arm: mach-omap2: gpmc: ignore non-available nodes
Thread-Topic: [PATCH] arm: mach-omap2: gpmc: ignore non-available nodes
Thread-Index: AQHPkU9QIYV16tLvvkWnS7l2srZ5bJuDOuqAgAkP2LA=
Date: Wed, 2 Jul 2014 05:33:37 +0000
Message-ID: <20980858CB6D3A4BAE95CA194937D5E73EAF8D44@DBDE04.ent.ti.com>
References: <1403794923-19511-1-git-send-email-guido@vanguardiasur.com.ar>
 <20140626163707.GA26836@arch.cereza>
In-Reply-To: <20140626163707.GA26836@arch.cereza>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From: Ezequiel García [mailto:ezequiel@vanguardiasur.com.ar]
>>On 26 Jun 12:02 PM, Guido Martínez wrote:
>> Currently, child nodes of the gpmc node are iterated and probed
>> regardless of their 'status' property. This means adding 'status =
>> "disabled";' has no effect.
>>
>> This patch changes the iteration to only probe nodes marked as
>> available.
>>
>> Signed-off-by: Guido Martínez <guido@vanguardiasur.com.ar>
>
>Just a nit: the commit title doesn't match the recent commits. If you
>run "git log" on this file, you'll find the pattern should be something
>like:
>
>"ARM: OMAP2+: GPMC should only probe enabled devices"
>
>Other than this, the patch looks correct.
>
Yes, plz keep patch title consistent as in other gpmc.c patches.
And thanks for this fix.

Tested-by: Pekon Gupta <pekon@ti.com>

with regards, pekon
