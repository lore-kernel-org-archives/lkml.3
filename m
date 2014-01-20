Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752326AbaATIRZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 03:17:25 -0500
Received: from mail-oa0-f51.google.com ([209.85.219.51]:36284 "EHLO
	mail-oa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbaATIRX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 03:17:23 -0500
MIME-Version: 1.0
In-Reply-To: <52D9BC5B.30304@wwwdotorg.org>
References: <1389912312-16285-1-git-send-email-linus.walleij@linaro.org>
	<52D989C2.6030603@broadcom.com>
	<CACRpkdYVLF+CNcAc8=MiSRJJMBWy3LriDw271Bx=gjuuzdOatA@mail.gmail.com>
	<CACRpkdZ9OBkKaLuQbc1oz0uPePBtqttGyOwV02iFWZ+CT1gwnw@mail.gmail.com>
	<52D9BC5B.30304@wwwdotorg.org>
Date: Mon, 20 Jan 2014 09:17:22 +0100
Message-ID: <CACRpkdZLDJ_+AnwXbPY9eEo8FHo8u8qy00Jc6Rr+9EUv+O5eiw@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: capri: add dependency on OF
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Sherman Yin <syin@broadcom.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Christian Daudt <bcm@fixthebug.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 18, 2014 at 12:27 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> On 01/17/2014 04:13 PM, Linus Walleij wrote:
>> On Sat, Jan 18, 2014 at 12:12 AM, Linus Walleij
>> <linus.walleij@linaro.org> wrote:
>>> On Fri, Jan 17, 2014 at 8:51 PM, Sherman Yin <syin@broadcom.com> wrote:
>>>
>>>> Thanks for the fix, Linus.  While we're visiting this config, should we add
>>>> "depends on MACH_BCM_MOBILE" as well?
>>>
>>> No, it's nice to get the compile coverage.
>>
>> But maybe you can experiment with that special option that only
>> turns on the driver on other platforms to do compile test.
>
> a/k/a
> depends on XXX || COMPILE_TEST

Yep, thanks Stephen :-)

Linus Walleij
