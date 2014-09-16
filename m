Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715AbaIPGlN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2014 02:41:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26794 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751229AbaIPGlJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2014 02:41:09 -0400
Message-ID: <5417DB68.8050108@redhat.com>
Date: Tue, 16 Sep 2014 08:40:40 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Kumar Gala <galak@codeaurora.org>, Tejun Heo <tj@kernel.org>
CC: linux-ide@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] ahci-platform: Bump max number of clocks to 5
References: <1410277008-20242-1-git-send-email-galak@codeaurora.org> <FDA51DE0-3F2C-48E3-81B7-5F2ABCEE6F61@codeaurora.org>
In-Reply-To: <FDA51DE0-3F2C-48E3-81B7-5F2ABCEE6F61@codeaurora.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/16/2014 04:09 AM, Kumar Gala wrote:
> 
> On Sep 9, 2014, at 8:36 AM, Kumar Gala <galak@codeaurora.org> wrote:
> 
>> Qualcomm IPQ806x SoCs with SATA controllers need 5 clocks to be enabled.
>>
>> Signed-off-by: Kumar Gala <galak@codeaurora.org>
>> ---
>> (reposted with Hans on list)
>>
>> v4:
>> * Updated to upstream changes
>>
>> drivers/ata/ahci.h | 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Any updates on these patches?

I send you a detailed review of this on 9 September, titled:

"Re: [PATCH v4 2/3] ata: Add Qualcomm ARM SoC AHCI SATA host controller driver"

I'll forward you that mail again right now.

Regards,

Hans
