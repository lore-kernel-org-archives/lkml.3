Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaCZKgA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 06:36:00 -0400
Received: from mail-lb0-f180.google.com ([209.85.217.180]:46056 "EHLO
	mail-lb0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751512AbaCZKf5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 06:35:57 -0400
Message-ID: <5332AD89.8030802@linaro.org>
Date: Wed, 26 Mar 2014 12:35:53 +0200
From: Taras Kondratiuk <taras.kondratiuk@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>
CC: Patch Tracking <patches@linaro.org>,
        Linaro Networking <linaro-networking@linaro.org>,
        Linaro Kernel <linaro-kernel@lists.linaro.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Victor Kamensky <victor.kamensky@linaro.org>
Subject: Re: [PATCH 0/4] ARM: OMAP: raw read and write endian fix
References: <1387822234-11167-1-git-send-email-taras.kondratiuk@linaro.org> <CAArO44vC4WKGHSqHX3+Mo5+jcNuyJLkh94+SPd4H+aZYAroYzw@mail.gmail.com> <20140108003927.GJ5074@atomide.com>
In-Reply-To: <20140108003927.GJ5074@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2014 02:39 AM, Tony Lindgren wrote:
> * Taras Kondratiuk <taras.kondratiuk@linaro.org> [131223 10:20]:
>> On 23 December 2013 20:10, Taras Kondratiuk <taras.kondratiuk@linaro.org> wrote:
>>> This series does trivial replacement of __raw_xxx functions with xxx_relaxed
>>> endian-neutral variants in 'mach-omap2' and 'plat-omap' directories.
>>> Some code here most probably won't be used in BE mode (like debug-leds for
>>> OMAP1 boards), but changes are made anyway to remove __raw_xxx() functions
>>> completely and simplify future grep'ing for new __raw_xxx() entries.
> 
> Sorry for the delay on these, applying into omap-for-v3.14/be.
> These are trivial, and it's actually nice that you left out the
> assembly related changes as those should be acked by the PM
> people in case there are some issues dealing with the ROM code
> etc.

Hi Tony,

It seems omap-for-v3.14/be didn't get into 3.14-rc8.
Is there any issue with them?

-- 
Taras Kondratiuk
