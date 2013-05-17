Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3EQEum (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 00:50:42 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:14184 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3EQEul (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 00:50:41 -0400
Message-ID: <5195B6D6.7030504@huawei.com>
Date: Fri, 17 May 2013 12:49:26 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <linux-mips@linux-mips.org>, LKML <linux-kernel@vger.kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] usb: omap2430: fix memleak in err case
References: <5192E650.3070303@huawei.com> <519377C4.1040800@cogentembedded.com>
In-Reply-To: <519377C4.1040800@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/5/15 19:55, Sergei Shtylyov wrote:
> Hello.
> 
> On 15-05-2013 5:35, Libo Chen wrote:
> 
>> when omap_get_control_dev fail, we should release relational platform_device
> 
>    s/fail/fails/, s/relational/related/?
> 
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> 
>    You've posted this to the wrong mailing list, linux-mips; devicetree-discuss also seems hardly related.
> 
> WBR, Sergei
> 
> 
> 

Hi Sergei,

Thank you for your remind.

