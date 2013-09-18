Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3IRWxs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 18:53:48 -0400
Received: from mms2.broadcom.com ([216.31.210.18]:3956 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751533Ab3IRWxq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 18:53:46 -0400
X-Server-Uuid: 4500596E-606A-40F9-852D-14843D8201B2
Message-ID: <523A2EEF.3070406@broadcom.com>
Date: Wed, 18 Sep 2013 15:53:35 -0700
From: "Christian Daudt" <csd@broadcom.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-Version: 1.0
To: "Lee Jones" <lee.jones@linaro.org>
cc: "Christian Daudt" <csd_b@daudt.org>, "Arnd Bergmann" <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Linux ARM Kernel" <linux-arm-kernel@lists.infradead.org>,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 06/22] ARM: dts: bcm281xx: Remove '0x's from
 BCM11351 DTS file
References: <1374490361-25769-1-git-send-email-lee.jones@linaro.org>
 <1374490361-25769-6-git-send-email-lee.jones@linaro.org>
 <51EDAC90.6010108@broadcom.com> <20130723075309.GE26801@laptop>
 <CAGFynZ-+UoML32ecX4nSGAaFJXqQpdq+D8j7GqJSKhxsE7w=9A@mail.gmail.com>
 <20130812135439.GF13851@lee--X1>
In-Reply-To: <20130812135439.GF13851@lee--X1>
X-WSS-ID: 7E24F2E51R092277223-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-08-12 06:54 AM, Lee Jones wrote:
> On Thu, 08 Aug 2013, Christian Daudt wrote:
>
>> Hi Lee,
>>   I had to change some of the lines in the dts files you modified, so
>> I've added your mods. This patch:
>> https://lkml.org/lkml/2013/8/8/477
>>
>> includes your changes to bcm11351.dtsi and bcm11351-brt.dts. Not sure
>> where your patch is at this point, but I just wanted to point that
>> out.
> I haven't done anything with that patch yet, but I'd prefer they
> stayed separate to be honest. If you make your changes and ensure
> they're in an upstream tree (and let me know which one), I'll rebase
> my patches on top of that tree.

These changes are in 3.12-rc1 now:
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d7358f845645c588aff84ac6b476a17d3eec75fa


  thanks,
    csd



