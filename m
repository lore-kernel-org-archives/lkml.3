Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593AbaILMow (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 08:44:52 -0400
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:54261 "EHLO
	smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754001AbaILMov convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 08:44:51 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Date: Fri, 12 Sep 2014 08:44:50 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_=5BPATCH=5D_iommu=3A_Make_of=5Fdevice=5Fid_array_const?=
From: kiran.padwal@smartplayin.com
To: "Will Deacon" <will.deacon@arm.com>
Cc: "joro@8bytes.org" <joro@8bytes.org>, "hdoyu@nvidia.com" <hdoyu@nvidia.com>,
        "swarren@wwwdotorg.org" <swarren@wwwdotorg.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "iommu@lists.linux-foundation.org" <iommu@lists.linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <20140911135119.GH6158@arm.com>
References: <1410442656-21112-1-git-send-email-kiran.padwal@smartplayin.com> 
 <20140911135119.GH6158@arm.com>
Message-ID: <1410525890.331211558@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thursday, September 11, 2014 9:51am, "Will Deacon" <will.deacon@arm.com> said:

> On Thu, Sep 11, 2014 at 02:37:36PM +0100, Kiran Padwal wrote:
>> Make of_device_id array const, because all OF functions handle it as const.
>>
>> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
>> ---
>>  drivers/iommu/arm-smmu.c   |    2 +-
>>  drivers/iommu/omap-iommu.c |    2 +-
>>  drivers/iommu/tegra-gart.c |    2 +-
>>  drivers/iommu/tegra-smmu.c |    2 +-
>>  4 files changed, 4 insertions(+), 4 deletions(-)
> 
> Ha, I've seen a few of these patches recently. Did some tool just get
> support for detecting this?

No

> 
> Anyway, looks fine and should probably go via Joerg.
> 
> Will
> 


