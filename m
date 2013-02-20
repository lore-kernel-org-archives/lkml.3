Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758995Ab3BTBim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 20:38:42 -0500
Received: from szxga01-in.huawei.com ([119.145.14.64]:2540 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757174Ab3BTBik (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 20:38:40 -0500
Message-ID: <51242908.2050308@huawei.com>
Date: Wed, 20 Feb 2013 09:38:16 +0800
From: Xishi Qiu <qiuxishi@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Tony Luck <tony.luck@gmail.com>
CC: Matt Fleming <matt.fleming@intel.com>, <fenghua.yu@intel.com>,
        Liujiang <jiang.liu@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-ia64@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-efi@vger.kernel.org>, <linux-mm@kvack.org>,
        Hanjun Guo <guohanjun@huawei.com>, WuJianguo <wujianguo@huawei.com>
Subject: Re: [PATCH V3] ia64/mm: fix a bad_page bug when crash kernel booting
References: <51074786.5030007@huawei.com> <1359995565.7515.178.camel@mfleming-mobl1.ger.corp.intel.com> <51131248.3080203@huawei.com> <5113450C.1080109@huawei.com> <CA+8MBbKuBheEj9t8whJBc=S7NdxCF8MvuD2Ajm7suP=7JC01fg@mail.gmail.com>
In-Reply-To: <CA+8MBbKuBheEj9t8whJBc=S7NdxCF8MvuD2Ajm7suP=7JC01fg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.74.196]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/2/20 5:56, Tony Luck wrote:

> Foolishly sent an earlier reply from Outlook which appears
> to have mangled/lost it. Trying again ...
> 
>> In efi_init() memory aligns in IA64_GRANULE_SIZE(16M). If set "crashkernel=1024M-:600M"
> 
> Is this where the real problem begins?  Should we insist that users

Hi Tony, I think this is the real problem begins and it only appears when use Sparse-Memory.

> provide crashkernel
> parameters rounded to GRANULE boundaries?
> 

Seems like a good idea, should we modify "\linux\Documentation\kernel-parameters.txt"?

Thanks,
Xishi Qiu

> -Tony
>  


