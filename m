Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755017AbaDOMvH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 08:51:07 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:64107 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853AbaDOMuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 08:50:18 -0400
Message-ID: <534D2B06.6000408@gmail.com>
Date: Tue, 15 Apr 2014 14:50:14 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Alexandre Belloni <alexandre.belloni@free-electrons.com>
CC: Jisheng Zhang <jszhang@marvell.com>,
        =?ISO-8859-1?Q?Antoine_T=E9nar?= =?ISO-8859-1?Q?t?= 
	<antoine.tenart@free-electrons.com>,
        Jimmy Xu <zmxu@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: berlin: add GPIO nodes for the BG2Q
References: <1397549245-3338-1-git-send-email-antoine.tenart@free-electrons.com> <1397549245-3338-3-git-send-email-antoine.tenart@free-electrons.com> <534CFA77.9030108@gmail.com> <20140415180058.2fefca78@xhacker> <534D0943.2050100@gmail.com> <20140415114848.GA2813@piout.net>
In-Reply-To: <20140415114848.GA2813@piout.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/15/2014 01:48 PM, Alexandre Belloni wrote:
> On 15/04/2014 at 12:26:11 +0200, Sebastian Hesselbarth wrote :
>> On 04/15/2014 12:00 PM, Jisheng Zhang wrote:
>>> On Tue, 15 Apr 2014 02:23:03 -0700
>>> Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com> wrote:
>>>> I am fine with using nr-gpios property now, but I guess BG2Q also
>>>> has that CONFIG[1,2] registers to actually read out the features
>>>> synthesized in? If I find some time, I'll prepare a patch for
>>>> dw-apb-gpio to exploit that (optional) information instead of
>>>> using nr-gpios.
>>>
>>> The problem is CONFIG1/2 registers don't exist on some versions.
>>> For example, the version used in BG2/BG2CD. So nr-gpio is necessary
>>> if we want to support these versions.
>>
>> Hmm, are you sure about BG2? I remember reading it and it contains
>> sane values. Anyway, a proper patch for dw-apb-gpio would include
>> checking for sane (e.g. non-zero) values. And nr-gpios will always
>> stay as fall-back just because e.g. sunxi does not have the CONFIG
>> registers.
>
> Shouldn't that be use nr-gpios and if not available, read the CONFIG
> registers? Else, what about bogus registers ?

Probably, it is a better idea to only look for CONFIG registers if
nr-gpios is not set. Anyway, I'll really have to find more time first ;)

Sebastian

