Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753665Ab3DOMPa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 08:15:30 -0400
Received: from mail-qe0-f54.google.com ([209.85.128.54]:55380 "EHLO
	mail-qe0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab3DOMP2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 08:15:28 -0400
Message-ID: <516BEF5A.7000101@gmail.com>
Date: Mon, 15 Apr 2013 07:15:22 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Olof Johansson <olof@lixom.net>, David Brown <davidb@codeaurora.org>
CC: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        grant.likely@secretlab.ca
Subject: Re: [GIT PULL] msm core for 3.10
References: <8ya7gk7qsnp.fsf@huya.qualcomm.com> <8yazjx3pdz0.fsf@huya.qualcomm.com> <20130415034905.GC10949@quad.lixom.net>
In-Reply-To: <20130415034905.GC10949@quad.lixom.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/14/2013 10:49 PM, Olof Johansson wrote:
> Hi,
> 
> On Fri, Apr 12, 2013 at 03:43:15PM -0700, David Brown wrote:
>> The following changes since commit f6161aa153581da4a3867a2d1a7caf4be19b6ec9:
>>
>>   Linux 3.9-rc2 (2013-03-10 16:54:19 -0700)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git tags/msm-core-3.10

>>  .../devicetree/bindings/arm/msm/timer.txt          |  41 ++++----
>>  arch/arm/boot/dts/msm8660-surf.dts                 |  20 ++--
>>  arch/arm/boot/dts/msm8960-cdp.dts                  |  22 ++---
>>  arch/arm/mach-msm/timer.c                          | 110 ++++++++++-----------
>>  4 files changed, 86 insertions(+), 107 deletions(-)
> 
> I didn't see either of the device tree maintainers cc:d on the bindings
> update, nor an ack from them. It looks reasonable enough to me, but I
> also do know that in your private downstream tree you have a lot of new
> bindings. Please make sure these go through proper review channels as
> you start to upstream them; i.e. Grant Likely and Rob Herring should
> either merge or ack them.
> 
> I've cc:d Rob and Grant on this reply and I'll merge it for now but to avoid
> delays in getting your code merged in the future please make sure they are in
> the loop from the beginning.

Other than breaking the DTB-kernel ABI, looks fine to me. It's a
platform decision whether they are okay with that or not.

Rob


