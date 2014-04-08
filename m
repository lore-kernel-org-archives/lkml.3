Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756112AbaDHDFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Apr 2014 23:05:44 -0400
Received: from mail-ig0-f179.google.com ([209.85.213.179]:33936 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755308AbaDHDFn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Apr 2014 23:05:43 -0400
MIME-Version: 1.0
In-Reply-To: <1396780101.30640.21.camel@x220>
References: <20140404174715.8250.22335@quantum>
	<1396780101.30640.21.camel@x220>
Date: Tue, 8 Apr 2014 11:05:42 +0800
Message-ID: <CAD6h2NQzU=O8K8yTwFHeCqKrx0+r1jhU4bQj+mDFABi4GqLyvg@mail.gmail.com>
Subject: Re: [GIT PULL] clk: changes for 3.15
From: Haojian Zhuang <haojian.zhuang@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Mike Turquette <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6 April 2014 18:28, Paul Bolle <pebolle@tiscali.nl> wrote:
> On Fri, 2014-04-04 at 10:47 -0700, Mike Turquette wrote:
>> Haojian Zhuang (3):
>>       [...]
>>       clk: hip04: add clock driver
>
> This clock driver is only built if CONFIG_ARCH_HIP04 is set. But I
> couldn't find a Kconfig symbol ARCH_HIP04. (I checked master of Linus'
> tree and current linux-next.)
>
> Is the code to add this symbol queued somewhere?
>
>
> Paul Bolle
>

Hi Paul,

ARCH_HIP04 patches are still in review stage. Those patches could be
found in arm-linux
mailing list. Clock patches of ARCH_HIP04 is ready, so it could be merged first.

Best Regards
Haojian
