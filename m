Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753072AbaBYNv1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 08:51:27 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:59880 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752352AbaBYNvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 08:51:25 -0500
Message-ID: <530C9FB6.9070600@ti.com>
Date: Tue, 25 Feb 2014 19:20:46 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Loc Ho <lho@apm.com>, <olof@lixom.net>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <ddutile@redhat.com>,
        <jcm@redhat.com>, <patches@apm.com>
Subject: Re: [PATCH RESEND v10 1/4] PHY: Add function set_speed to generic
 PHY framework
References: <1393308882-3964-1-git-send-email-lho@apm.com> <1393308882-3964-2-git-send-email-lho@apm.com> <530C8711.4000600@ti.com> <20140225134517.GA26189@htj.dyndns.org>
In-Reply-To: <20140225134517.GA26189@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 February 2014 07:15 PM, Tejun Heo wrote:
> On Tue, Feb 25, 2014 at 05:35:37PM +0530, Kishon Vijay Abraham I wrote:
>> Hi,
>>
>> On Tuesday 25 February 2014 11:44 AM, Loc Ho wrote:
>>> This patch adds function set_speed to the generic PHY framework operation
>>> structure. This function can be called to instruct the PHY underlying layer
>>> at specified lane to configure for specified speed in hertz.
>>>
>>> Signed-off-by: Loc Ho <lho@apm.com>
>>> ---
>>>  drivers/phy/phy-core.c  |   21 +++++++++++++++++++++
>>>  include/linux/phy/phy.h |    8 ++++++++
>>>  2 files changed, 29 insertions(+), 0 deletions(-)
>>>
>>> diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
>>> index 645c867..44f2f63 100644
>>> --- a/drivers/phy/phy-core.c
>>> +++ b/drivers/phy/phy-core.c
>>> @@ -257,6 +257,27 @@ int phy_power_off(struct phy *phy)
>>>  }
>>>  EXPORT_SYMBOL_GPL(phy_power_off);
>>>  
>>
>> missing function comment :-s
> 
> Can you please let me know when this series goes in?  I'll pull in the
> phy tree into libata and then apply the ata patches on top.

I'll send the final pull request for 3.15 merge window by next weekend to Greg
kh. Before that I'd like to have my comments addressed in this patch series.

Thanks
Kishon
