Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753347AbaCKGF3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2014 02:05:29 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:33481 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791AbaCKGF0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2014 02:05:26 -0400
Message-ID: <531EA77C.103@ti.com>
Date: Tue, 11 Mar 2014 11:34:44 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>, Loc Ho <lho@apm.com>
CC: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Don Dutile <ddutile@redhat.com>, Jon Masters <jcm@redhat.com>,
        "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>,
        Suman Tripathi <stripathi@apm.com>
Subject: Re: [PATCH v15 3/3] arm64: Add APM X-Gene SoC 15Gbps Multi-purpose
 PHY DTS entries
References: <1394213289-29565-1-git-send-email-lho@apm.com> <1394213289-29565-2-git-send-email-lho@apm.com> <1394213289-29565-3-git-send-email-lho@apm.com> <1394213289-29565-4-git-send-email-lho@apm.com> <CAPw-ZTmwFZjKT2+CUUp73TDXJcXy-bEY_sTNg-TtH-COzDnCfw@mail.gmail.com> <20140310204549.GJ25290@htj.dyndns.org>
In-Reply-To: <20140310204549.GJ25290@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Tuesday 11 March 2014 02:15 AM, Tejun Heo wrote:
> On Sun, Mar 09, 2014 at 10:23:33PM -0700, Loc Ho wrote:
>> Hi Tejun,
>>
>> On Fri, Mar 7, 2014 at 9:28 AM, Loc Ho <lho@apm.com> wrote:
>>
>>> This patch adds the DTS entries for the APM X-Gene SoC 15Gbps Multi-purpose
>>> PHY driver. The PHY for SATA controller 2 and 3 are enabled by default.
>>>
>>> Signed-off-by: Loc Ho <lho@apm.com>
>>> Signed-off-by: Tuan Phan <tphan@apm.com>
>>> Signed-off-by: Suman Tripathi <stripathi@apm.com>
>>> ---
>>>   arch/arm64/boot/dts/apm-storm.dtsi |   75
>>> ++++++++++++++++++++++++++++++++++++
>>>   1 files changed, 75 insertions(+), 0 deletions(-)
>>>
>>>
>> Kishon had pulled in the PHY doc/driver patches. Will you pulling in the
>> PHY DTS and the SATA host driver patches soon?
>
> Kishon, is the following branch the right one to pull into
> libata/for-3.15?
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git next


My PULL request to Greg has this..
git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git 
tags/for_3.15

Btw you can add my
Acked-by: Kishon Vijay Abraham I <kishon@ti.com>
for this patch.

Thanks
Kishon
