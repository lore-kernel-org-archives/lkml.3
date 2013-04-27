Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756693Ab3D0AWH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Apr 2013 20:22:07 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:64785 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755842Ab3D0AWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Apr 2013 20:22:05 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:1b02:6e3b:e5ff:fe16:c028]
In-Reply-To: <517B16FF.6070008@infradead.org>
References: <1367019591-31685-1-git-send-email-olof@lixom.net>
	<517B16FF.6070008@infradead.org>
Date: Fri, 26 Apr 2013 17:22:03 -0700
Message-ID: <CAOesGMg0_Awi_b--tuEDFU8tZUqTA46RWuiiBP7=ct00O7zcEw@mail.gmail.com>
Subject: Re: [PATCH] clk: add option to keep boot clocks on
From: Olof Johansson <olof@lixom.net>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 26, 2013 at 5:08 PM, Randy Dunlap <rdunlap@infradead.org> wrote:
> On 04/26/13 16:39, Olof Johansson wrote:
>> This is primarily useful when there's a driver that doesn't claim clocks
>> properly, but the bootloader does. It's not expected to be used in normal
>> cases, but for bringup and debug it's very useful to have the option to
>> not gate unclaimed clocks that are still on.
>>
>> Signed-off-by: Olof Johansson <olof@lixom.net>
>
> add to Documentation/kernel-parameters.txt or somewhere else?

Ah, yes, of course. I'll wait for Mike to provide input on the color
of the shed, since it might change location in the file if it's
renamed. And then repost with documentation update.


-Olof
