Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756310AbaLWP7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 10:59:34 -0500
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:53962 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178AbaLWP7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 10:59:32 -0500
X-IronPort-AV: E=Sophos;i="5.07,632,1413270000"; 
   d="scan'208";a="53822714"
Message-ID: <54999161.504@broadcom.com>
Date: Tue, 23 Dec 2014 16:59:29 +0100
From: Arend van Spriel <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.24) Gecko/20111103 Lightning/1.0b2 Thunderbird/3.1.16
MIME-Version: 1.0
To: Mika Westerberg <mika.westerberg@linux.intel.com>
CC: <linux-wireless@vger.kernel.org>, Brett Rudley <brudley@broadcom.com>,
        Hante Meuleman <meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "John W. Linville" <linville@tuxdriver.com>,
        Christophe Prigent <christophe.prigent@intel.com>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] brcmfmac: Do not crash if platform data is not populated
References: <1419346112-173303-1-git-send-email-mika.westerberg@linux.intel.com> <54998C31.9090500@broadcom.com> <20141223154738.GM1314@lahna.fi.intel.com>
In-Reply-To: <20141223154738.GM1314@lahna.fi.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/23/14 16:47, Mika Westerberg wrote:
> On Tue, Dec 23, 2014 at 04:37:21PM +0100, Arend van Spriel wrote:
>> On 12/23/14 15:48, Mika Westerberg wrote:
>>> The driver looks for pdata->oob_irq_supported to find out if wowl can be
>>> supported. However, not all platforms populate pdata in which case we crash
>>> the kernel because of NULL pointer dereference.
>>
>> Thanks, Mika
>>
>> However, this was already reported by Dan Carpenter and I submitted a patch
>> for that a couple of days ago: "[PATCH 02/10] brcmfmac: Fix possible
>> dereference of NULL pointer." [1].
>>
>> Regards,
>> Arend
>>
>> [1]
>> http://mid.gmane.org/1419162233-19492-3-git-send-email-arend@broadcom.com
>
> Oh, good. I didn't notice that one.
>
> Thanks for fixing it :)
>
> BTW, that patch seems to miss brcmf_ops_sdio_resume(), perhaps it is
> fixed in another patch?

Aargh, a nice "BTW" this is as there is no other patch for the resume 
code. Maybe I should ask Kalle to apply your patch instead of ours. If 
it did not already got applied.

Regards,
Arend
