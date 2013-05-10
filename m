Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757098Ab3EJBKN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 21:10:13 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:16451 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753669Ab3EJBKL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 21:10:11 -0400
Message-ID: <518C48AF.6070701@huawei.com>
Date: Fri, 10 May 2013 09:09:03 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: Libo Chen <libo.chen@huawei.com>, <stern@rowland.harvard.edu>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <akpm@linux-foundation.org>, <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 4/4] usb: tilegx: fix memleak when create hcd fail
References: <1368079537-15328-1-git-send-email-libo.chen@huawei.com> <1368079537-15328-5-git-send-email-libo.chen@huawei.com> <518BE49D.4080602@tilera.com>
In-Reply-To: <518BE49D.4080602@tilera.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/10 2:02, Chris Metcalf wrote:
> On 5/9/2013 2:08 AM, Libo Chen wrote:
>> When usb_create_hcd fail, we should call gxio_usb_host_destroy
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> ---
>>  drivers/usb/host/ohci-tilegx.c |    7 +++++--
>>  1 files changed, 5 insertions(+), 2 deletions(-)
> 
> Thanks; taken into the tile tree.  I also made the same change to ehci-tilegx.c.
> 

Hi Chris,

Thanks reply, May be I miss. Please ignore this patch.


