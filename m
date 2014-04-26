Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaDZJxw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 05:53:52 -0400
Received: from mail-ee0-f49.google.com ([74.125.83.49]:55865 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751028AbaDZJxu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 05:53:50 -0400
Message-ID: <535B822A.10301@gmail.com>
Date: Sat, 26 Apr 2014 11:53:46 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
To: Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?B?QW50b2luZSBUw6luYQ==?= =?UTF-8?B?cnQ=?= 
	<antoine.tenart@free-electrons.com>
CC: Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] ARM: berlin: add pinctrl support
References: <1398268276-9696-1-git-send-email-antoine.tenart@free-electrons.com> <CACRpkdYaX_9KRTTwvmxJXo-sG7AK2u-ggrNHY+FS3qQCQhudRA@mail.gmail.com>
In-Reply-To: <CACRpkdYaX_9KRTTwvmxJXo-sG7AK2u-ggrNHY+FS3qQCQhudRA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/25/2014 11:13 AM, Linus Walleij wrote:
> On Wed, Apr 23, 2014 at 5:51 PM, Antoine Ténart
> <antoine.tenart@free-electrons.com> wrote:
> 
>> This series adds support for the Marvell Berlin pin-controller, allowing
>> to configure the pin muxing from the device tree.
> 
> I've looked over the patch series and there is nothing really controversial in
> there, but I'm waiting for Thomas & Sebastian to provide Reviewed-by
> tags.

Ok, great! I had some minor remarks but mainly cosmetic nits. As soon
as Antoine resends a final v3, feel free to take patches 1-4. I will
pick up 6 and 7 then.

Sebastian

