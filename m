Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaLANHH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 08:07:07 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:57052 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753455AbaLANHE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 08:07:04 -0500
Message-ID: <547C67F3.7080807@gmail.com>
Date: Mon, 01 Dec 2014 21:06:59 +0800
From: Zhou Wang <wangzhou.bry@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Brian Norris <computersforpeace@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        devicetree@vger.kernel.org, mark.rutland@arm.com, pawel.moll@arm.com,
        ijc+devicetree@hellion.org.uk, robh+dt@kernel.org,
        galak@codeaurora.org, caizhiyong@huawei.com, haojian.zhuang@gmail.com,
        xuwei5@hisilicon.com, wangzhou1@hisilicon.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/2] mtd: hisilicon: add a new driver for NAND controller
 of hisilicon hip04 Soc
References: <1415105221-7732-1-git-send-email-wangzhou.bry@gmail.com> <20141130090853.GG3608@norris-Latitude-E6410>
In-Reply-To: <20141130090853.GG3608@norris-Latitude-E6410>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014年11月30日 17:08, Brian Norris wrote:
> On Tue, Nov 04, 2014 at 08:46:59PM +0800, Zhou Wang wrote:
>> This patchset adds the support for NAND controller of hisilicon hip04 Soc.
>> The NAND controller IP was developed by hisilicon and needs a new driver to
>> support it. This patchset is based on v3.18-rc1. I have tested that NAND flash
>> controller works fine in Hip04 D01 board.
>
> Have you tested on the MTD test modules (drivers/mtd/tests/*)? This is
> important, as we seem to regularly get UBIFS bug reports from users
> whose drivers have not even passed some of the simple tests.
>
> Also, it might be worth testing out the UBI tests found in the mtd-utils
> package.
>
> Brian
>

Hi Brian,

I have not tested on the MTD test modules, I will do this test and
the UBI tests ASAP. Thank you very much for so many helpful comments!

Best Regards,
Zhou Wang
