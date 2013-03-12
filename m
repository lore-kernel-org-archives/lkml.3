Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab3CLLho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 07:37:44 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:52827 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932966Ab3CLLhl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 07:37:41 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:1f05:1640:b54d:b01c:d9fb:846b]
In-Reply-To: <20130312111246.GD12700@titan.lakedaemon.net>
References: <20130312144714.39749c5b0bd1aea14c4d2ff8@canb.auug.org.au>
	<20130312062509.GQ21478@lunn.ch>
	<20130312111246.GD12700@titan.lakedaemon.net>
Date: Tue, 12 Mar 2013 04:37:39 -0700
Message-ID: <CAOesGMgSzn+uCVEMKZgtorcNkdzzvntmnfoej5vN-AjF43pnyQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
From: Olof Johansson <olof@lixom.net>
To: Jason Cooper <jason@lakedaemon.net>
Cc: Andrew Lunn <andrew@lunn.ch>, Stephen Rothwell <sfr@canb.auug.org.au>,
        Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jingoo Han <jg1.han@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 4:12 AM, Jason Cooper <jason@lakedaemon.net> wrote:
> On Tue, Mar 12, 2013 at 07:25:09AM +0100, Andrew Lunn wrote:
>> On Tue, Mar 12, 2013 at 02:47:14PM +1100, Stephen Rothwell wrote:
>> > Hi Andrew,
>> >
>> > Today's linux-next merge of the akpm tree got a conflict in
>> > drivers/rtc/rtc-mv.c between commit 89c58c198b25 ("rtc: rtc-mv: Add
>> > support for clk to avoid lockups") from the arm-soc tree and commit "rtc:
>> > rtc-mv: use devm_rtc_device_register()" from the akpm tree.
>> >
>> > I fixed it up (I think - see below) and can carry the fix as necessary
>> > (no action is required).
>>
>> Hi Stephan
>>
>> Looks O.K. to me.
>>
>> Acked-by: Andrew Lunn <andrew@lunn.ch>
>
> Same here,
>
> Acked-by: Jason Cooper <jason@lakedaemon.net>

We should make sure that future RTC changes get queued through AKPM
and not through us to avoid these kind of conflicts. Same as other
driver subsystems..


-Olof
