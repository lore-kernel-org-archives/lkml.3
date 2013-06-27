Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752069Ab3F0Ew2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jun 2013 00:52:28 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:51176 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750993Ab3F0Ew1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jun 2013 00:52:27 -0400
Message-ID: <51CBC4C9.7080809@ti.com>
Date: Thu, 27 Jun 2013 10:21:21 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Kamlakant Patel <kamlakant.patel@broadcom.com>
CC: <linux-mtd@lists.infradead.org>, <spi-devel-general@lists.sourceforge.net>,
        <broonie@kernel.org>, <dwmw2@infradead.org>, <manonuevo@micron.com>,
        <tqnguyen@micron.com>, <grant.likely@linaro.org>,
        <linux-omap@vger.kernel.org>, <rnayak@ti.com>,
        <linux-kernel@vger.kernel.org>, <balbi@ti.com>
Subject: Re: [PATCH 1/3] drivers: mtd: spinand: Add generic spinand frameowrk
 and micron driver.
References: <1372232472-2641-1-git-send-email-sourav.poddar@ti.com> <1372232472-2641-2-git-send-email-sourav.poddar@ti.com> <20130626152243.GA9414@kpatel.netlogicmircro.com>
In-Reply-To: <20130626152243.GA9414@kpatel.netlogicmircro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Kamlakant,
On Wednesday 26 June 2013 08:52 PM, Kamlakant Patel wrote:
> On Wed, Jun 26, 2013 at 01:11:10PM +0530, Sourav Poddar wrote:
>> From: Mona Anonuevo<manonuevo@micron.com>
>>
>> This patch adds support for a generic spinand framework(spinand_mtd.c).
>> This frameowrk can be used for other spi based flash devices also. The idea
>> is to have a common model under drivers/mtd, as also present for other no spi
>> devices(there is a generic framework and device part simply attaches itself to it.)
>>
>> The generic frework will be used later by me for a SPI based spansion S25FL256 device.
>> The patch also contains a micron driver attaching itself to generic framework.
>>
>> Signed-off-by: Mona Anonuevo<manonuevo@micron.com>
>> Signed-off-by: Tuan Nguyen<tqnguyen@micron.com>
>> Signed-off-by: Sourav Poddar<sourav.poddar@ti.com>
>> ----
>> [I picked this as a standalone patch, can split it into generic and device part
>> based on community feedback.]
>>
>>   drivers/mtd/Kconfig               |    2 +
>>   drivers/mtd/Makefile              |    2 +
>>   drivers/mtd/spinand/Kconfig       |   24 ++
>>   drivers/mtd/spinand/Makefile      |   10 +
>>   drivers/mtd/spinand/spinand_lld.c |  776 +++++++++++++++++++++++++++++++++++++
>>   drivers/mtd/spinand/spinand_mtd.c |  690 +++++++++++++++++++++++++++++++++
>>   include/linux/mtd/spinand.h       |  155 ++++++++
>>   7 files changed, 1659 insertions(+), 0 deletions(-)
>>   create mode 100644 drivers/mtd/spinand/Kconfig
>>   create mode 100644 drivers/mtd/spinand/Makefile
>>   create mode 100644 drivers/mtd/spinand/spinand_lld.c
>>   create mode 100644 drivers/mtd/spinand/spinand_mtd.c
>>   create mode 100644 include/linux/mtd/spinand.h
>>
> I am working on Micron SPINAND(Micron MT29F1G01ZACH). I tried this patch, but it's not working.
> It is throwing following error message while mounting:
> [  260.232000] jffs2: cannot read OOB for EB at 00000000, requested 8 bytes, read 0 bytes, error -22
> mount: mounting /dev/mtdblock5 on /mnt/ failed: Input/output error
>
> I am working on it to fix into the driver, will send an updated patch with the fix.
>
Thanks for replying on this.
Since, this patch is already posted, I think it will be better if you post
the delta fix on top of this patch.
> Thanks,
> Kamlakant Patel
>

