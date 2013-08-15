Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3HOJ2K (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 05:28:10 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:11262 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab3HOJ2I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 05:28:08 -0400
Message-ID: <520C9F0C.6040303@huawei.com>
Date: Thu, 15 Aug 2013 17:27:40 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Li Zefan <lizefan@huawei.com>
Subject: Re: [PATCH RESEND 1/8] net: fsl_pq_mdio: use platform_{get,set}_drvdata()
References: <5208E215.6030007@huawei.com> <520AFBEE.7030903@huawei.com> <520BD275.5060004@cogentembedded.com>
In-Reply-To: <520BD275.5060004@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/15 2:54, Sergei Shtylyov wrote:
> Hello.
> 
> On 08/14/2013 07:39 AM, Libo Chen wrote:
> 
>> We can use the wrapper functions platform_{get,set}_drvdata() instead of
>> dev_{get,set}_drvdata() with &pdev->dev, it is convenient for user.
> 
>> Also, unnecessary dev_set_drvdata() is removed, because the driver core
>> clears the driver data to NULL after device_release or on probe failure.
> 
>    You misunderstood. That's a material for 2 separate patch sets (or maybe single patches, since multiple files can be collapsed in a single patch).
> 

 okay, thanks.


Libo

>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> 
> WBR, Sergei
> 
> 
> 


