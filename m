Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753726AbaJ2AsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 20:48:13 -0400
Received: from mail-qg0-f45.google.com ([209.85.192.45]:48921 "EHLO
	mail-qg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858AbaJ2AsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 20:48:12 -0400
MIME-Version: 1.0
X-Originating-IP: [59.115.233.222]
In-Reply-To: <2588271.FpfytU43Wu@wuerfel>
References: <1413733260.6272.1.camel@phoenix>
	<CACRpkdaTcxngj6MLGHUyx-AbB3o4iV2dtsmCCVHwacuDp=0D3A@mail.gmail.com>
	<2588271.FpfytU43Wu@wuerfel>
Date: Wed, 29 Oct 2014 08:48:11 +0800
Message-ID: <CAFRkauAP9+6VM40O-WLMKY5X5WrpyrCqBhjwVbWGSV2B_+DPXg@mail.gmail.com>
Subject: Re: [PATCH] soc: versatile: Add terminating entry for realview_soc_of_match
From: Axel Lin <axel.lin@ingics.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        arm@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Arnd are you merging this directly into ARM SoC?
>>
>
> Applied to the fixes branch.
Thanks.
>
> Please remember to add arm@kernel.org when you want us to pick up the
> patches.
scripts/get_maintainer.pl does not suggest arm@kernel.org for this patch.

$ scripts/get_maintainer.pl
0001-soc-versatile-Add-terminating-entry-for-realview_soc.patch
Linus Walleij <linus.walleij@linaro.org>
(commit_signer:1/1=100%,authored:1/1=100%,added_lines:144/144=100%)
Arnd Bergmann <arnd@arndb.de> (commit_signer:1/1=100%)
linux-kernel@vger.kernel.org (open list)

Maybe it needs update the maintainer entry?

Axel
