Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742AbaJ1J6M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 05:58:12 -0400
Received: from smtp105.iad3a.emailsrvr.com ([173.203.187.105]:44562 "EHLO
	smtp105.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752176AbaJ1J6L convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 05:58:11 -0400
X-Sender-Id: kiran.padwal@smartplayin.com
Date: Tue, 28 Oct 2014 05:58:09 -0400 (EDT)
Subject: =?utf-8?Q?Re=3A_=5BPATCH=5D_iommu=3A_use_dev=5Fget=5Fplatdata=28=29?=
From: kiran.padwal@smartplayin.com
To: "Joerg Roedel" <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8BIT
Importance: Normal
X-Priority: 3 (Normal)
X-Type: plain
In-Reply-To: <20141022143021.GI10074@8bytes.org>
References: <1412947870-10033-1-git-send-email-kiran.padwal@smartplayin.com> 
 <20141022143021.GI10074@8bytes.org>
X-Auth-ID: kiran.padwal@smartplayin.com
Message-ID: <1414490289.8326098@apps.rackspace.com>
X-Mailer: webmail7.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wednesday, October 22, 2014 10:30am, "Joerg Roedel" <joro@8bytes.org> said:

> On Fri, Oct 10, 2014 at 07:01:10PM +0530, Kiran Padwal wrote:
>> Use the wrapper function for retrieving the platform data instead of
>> accessing dev->platform_data directly.
>>
>> Signed-off-by: Kiran Padwal <kiran.padwal@smartplayin.com>
>> ---
>>  drivers/iommu/msm_iommu_dev.c |    4 ++--
>>  drivers/iommu/omap-iommu.c    |    6 +++---
>>  2 files changed, 5 insertions(+), 5 deletions(-)
> 
> This touches 2 drivers, can you please split it up into per-driver
> patches?

Sure, I will resent the separate patches.
sorry for delayed response.
 
Thanks,
--Kiran

