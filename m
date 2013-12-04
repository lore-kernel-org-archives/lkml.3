Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab3LDIBb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 03:01:31 -0500
Received: from mx0b-0016f401.pphosted.com ([67.231.156.173]:35939 "EHLO
	mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753592Ab3LDIBa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 03:01:30 -0500
Message-ID: <529EE143.80601@marvell.com>
Date: Wed, 4 Dec 2013 16:01:07 +0800
From: Qiao Zhou <zhouqiao@marvell.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130330 Thunderbird/17.0.5
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@intel.com>
CC: "eric.y.miao@gmail.com" <eric.y.miao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Vinod Koul <vinod.koul@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "dmaengine@vger.kernel.org" <dmaengine@vger.kernel.org>,
        Chao Xie <cxie4@marvell.com>
Subject: Re: [PATCH 1/2] arm: mmp: build sram driver alone
References: <1386140747-16043-1-git-send-email-zhouqiao@marvell.com> <CAPcyv4iMFCmQVbqphkcuKTsMg-YzApyPM2DnO-JY3htLhnrMXg@mail.gmail.com>
In-Reply-To: <CAPcyv4iMFCmQVbqphkcuKTsMg-YzApyPM2DnO-JY3htLhnrMXg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.72,1.0.14,0.0.0000
 definitions=2013-12-04_03:2013-12-03,2013-12-04,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 spamscore=0 suspectscore=0
 phishscore=0 adultscore=0 bulkscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=7.0.1-1305240000 definitions=main-1312030300
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/04/2013 03:56 PM, Dan Williams wrote:
> On Tue, Dec 3, 2013 at 11:05 PM, Qiao Zhou <zhouqiao@marvell.com> wrote:
>> sram driver can be used by many chips besides CPU_MMP2, and so build
>> it alone.
>>
>> Reported-by: Dan Williams <dan.j.williams@intel.com>
>> Signed-off-by: Qiao Zhou <zhouqiao@marvell.com>
>> ---
>>   arch/arm/mach-mmp/Kconfig  |    5 +++++
>>   arch/arm/mach-mmp/Makefile |    3 ++-
>>   2 files changed, 7 insertions(+), 1 deletions(-)
>>
>> diff --git a/arch/arm/mach-mmp/Kconfig b/arch/arm/mach-mmp/Kconfig
>> index ebdda83..6a6597c 100644
>> --- a/arch/arm/mach-mmp/Kconfig
>> +++ b/arch/arm/mach-mmp/Kconfig
>> @@ -136,4 +136,9 @@ config USB_EHCI_MV_U2O
>>          help
>>            Enables support for OTG controller which can be switched to host mode.
>>
>> +config MMP_SRAM
>> +       bool
>> +       help
>> +         Select code specific to sram.
>> +
>
> No need for help text for something that is selected, and might as
> well squash this with patch 2.
>
Dan, thanks. I'll update it.

-- 

Best Regards
Qiao
