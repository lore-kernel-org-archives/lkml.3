Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464AbaENGNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 02:13:19 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62986 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071AbaENGNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 02:13:15 -0400
Message-ID: <53730967.6030403@linaro.org>
Date: Wed, 14 May 2014 14:12:55 +0800
From: "kefeng.wang" <kefeng.wang@linaro.org>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Hans de Goede <hdegoede@redhat.com>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        wangkefeng.wang@huawei.com, xuwei5@hisilicon.com
Subject: Re: [PATCH v6 3/3] ahci: add support for Hisilicon sata
References: <1398416351-30567-1-git-send-email-kefeng.wang@linaro.org> <1398416351-30567-4-git-send-email-kefeng.wang@linaro.org> <20140513190427.GA28815@htj.dyndns.org>
In-Reply-To: <20140513190427.GA28815@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-5-14 3:04, Tejun Heo wrote:
> On Fri, Apr 25, 2014 at 04:59:11PM +0800, Kefeng Wang wrote:
>> The hip04 SoC of hisilicon has an AHCI compliant SATA controller,
>> and it is compliant with the ahci 1.3 and sata 3.0 specification.
>>
>> There is a wrong bit in HOST_CAP of hip04 sata controller, which
>> enable unsupported feature of FBS, use AHCI_HFLAG_NO_FBS hflag to
>> disable it.
>>
>> Signed-off-by: Kefeng Wang <kefeng.wang@linaro.org>
> 
> Doesn't apply to libata/for-3.16.  Please refresh.

Send new patches, rebased onto libata/for-3.16, based on commit: 58eb8cd565af.
Is this OK, if not, please let me know, thanks.

> 
> Thanks.
> 

