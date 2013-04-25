Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757787Ab3DYMp4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 08:45:56 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:43128 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755651Ab3DYMpz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 08:45:55 -0400
MIME-Version: 1.0
In-Reply-To: <20130425091744.GF4623@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
	<1366279934-30761-8-git-send-email-lee.jones@linaro.org>
	<CACRpkdbCMjC22WbgE_-Co-hvT704n696Ox8t_6_d2aoxmZyybA@mail.gmail.com>
	<20130425091744.GF4623@gmail.com>
Date: Thu, 25 Apr 2013 14:45:54 +0200
Message-ID: <CACRpkdbhygnrtosb5PRQ_5JbURpeH7pM-xj-m1wLP8Yq3HCLcg@mail.gmail.com>
Subject: Re: [PATCH 07/32] ARM: ux500: Supply address location names for the
 DMA40 DMA controller
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 25, 2013 at 11:17 AM, Lee Jones <lee.jones@linaro.org> wrote:
> On Thu, 25 Apr 2013, Linus Walleij wrote:
>
>> On Thu, Apr 18, 2013 at 12:11 PM, Lee Jones <lee.jones@linaro.org> wrote:
>>
>> > The DMA40 controller uses two sets of base addresses. In order to have
>> > them automatically setup as resources by the Open Format framework we
>> > have to set names for them. The names have to be the same as the ones
>> > used to fetch them back out of the resource structure.
>> >
>> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
>>
>> This is OK with Arnds suggested changed, but I want the patch
>> split off from this series and put into a device-tree-specific patch
>> series so I can apply this to a branch where I try to keep
>> all patches to the device tree files. (ux500-devicetree).
>
> Do you want to take this one separately?
>
> Feel free and I'll remove it from this set.

The problem I'm facing in the ux500 tree is that different changes
to the device tree files are colliding like hell.

So I really need those changes (to those files) to come in
separately. Usually the changes are orthogonal anyway, and
the DT stuff "could" be maintained as if it was out-of-tree.

At the core of that is basically that the DT files have a higher
evolutionary pace than the kernel code and that is straining the
merge model.

Yours,
Linus Walleij
