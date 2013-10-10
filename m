Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755546Ab3JJPjJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 11:39:09 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:50216 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754604Ab3JJPjG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 11:39:06 -0400
MIME-Version: 1.0
In-Reply-To: <5256728C.6060802@nvidia.com>
References: <1380729030-25896-1-git-send-email-ldewangan@nvidia.com>
	<1380729030-25896-3-git-send-email-ldewangan@nvidia.com>
	<CACRpkdbmAnRxDpP17tmAAeC7U6Yibd5N7vFA1o1h=4DdhW+H-g@mail.gmail.com>
	<5256728C.6060802@nvidia.com>
Date: Thu, 10 Oct 2013 17:39:04 +0200
Message-ID: <CACRpkdb8kRQLdAU+FKa4zwVpAotZ4+5J59b=yJz6VoGQ6QbwDA@mail.gmail.com>
Subject: Re: [rtc-linux] [PATCH V5 2/3] pincntrl: add support for ams AS3722
 pin control driver
From: Linus Walleij <linus.walleij@linaro.org>
To: "rtc-linux@googlegroups.com" <rtc-linux@googlegroups.com>
Cc: Lee Jones <lee.jones@linaro.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>, Rob Landley <rob@landley.net>,
        "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>,
        Grant Likely <grant.likely@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 11:25 AM, Laxman Dewangan <ldewangan@nvidia.com> wrote:
> On Tuesday 08 October 2013 05:46 PM, Linus Walleij wrote:
>> On Wed, Oct 2, 2013 at 5:50 PM, Laxman Dewangan <ldewangan@nvidia.com>
>> wrote:

>>> Changes from V4:
>>> - Drop separate DT binding document as it is moved to mfd/as3722.txt.
>>
>> As mentioned I am happy with this driver,
>> Acked-by: Linus Walleij <linus.walleij@linaro.org>
>>
>> When you agreed with the DT folks and want me to merge it,
>> tell me.
>
> Stephen has given the ACK from DT side, so I think you can merge this patch.

OK patch applied.

Yours,
Linus Walleij
