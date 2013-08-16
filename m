Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753077Ab3HPBJu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Aug 2013 21:09:50 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:26234 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab3HPBJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Aug 2013 21:09:49 -0400
Message-ID: <520D7BBE.4090401@huawei.com>
Date: Fri, 16 Aug 2013 09:09:18 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <michal.simek@xilinx.com>, <renner@efe-gmbh.de>,
        <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>,
        <lizefan@huawei.com>, <sergei.shtylyov@cogentembedded.com>,
        <monstr@monstr.eu>
Subject: Re: [PATCH v3 6/7] net: xilinx_emaclite: use platform_{get,set}_drvdata()
References: <520CD13B.2060702@huawei.com> <20130815.152320.567038346349607100.davem@davemloft.net>
In-Reply-To: <20130815.152320.567038346349607100.davem@davemloft.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/16 6:23, David Miller wrote:
> From: Libo Chen <clbchenlibo.chen@huawei.com>
> Date: Thu, 15 Aug 2013 21:01:47 +0800
> 
>> Use the wrapper functions for getting and setting the driver data using
>> platform_device instead of using dev_{get,set}_drvdata() with &of_dev->dev,
>> so we can directly pass a struct platform_device.
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
> 
> Why did you not CC: netdev on this patch?
> 

oh, my script doesn`t work well!

> 


