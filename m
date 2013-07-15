Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab3GOAvg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Jul 2013 20:51:36 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:8114 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753261Ab3GOAvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Jul 2013 20:51:35 -0400
Message-ID: <51E34785.20703@huawei.com>
Date: Mon, 15 Jul 2013 08:51:17 +0800
From: Yijing Wang <wangyijing@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Paul Bolle <pebolle@tiscali.nl>
CC: Bjorn Helgaas <bhelgaas@google.com>, <linux-kernel@vger.kernel.org>,
        <linux-pci@vger.kernel.org>, Rafael <rjw@sisk.pl>,
        Hanjun Guo <guohanjun@huawei.com>, <jiang.liu@huawei.com>
Subject: Re: [PATCH -v2 0/3] Use PCIe DSN to improve pciehp_resume
References: <1373535825-49972-1-git-send-email-wangyijing@huawei.com>  <1373552385.1349.2.camel@x61.thuisdomein> <51DF6150.8010401@huawei.com> <1373710849.1352.29.camel@x61.thuisdomein>
In-Reply-To: <1373710849.1352.29.camel@x61.thuisdomein>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.76.69]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/7/13 18:20, Paul Bolle wrote:
> Yijing,
> 
> On Fri, 2013-07-12 at 09:52 +0800, Yijing Wang wrote:
>> Do you wireless card support Device Serial Number ?
>> You can confirm it by lspci -vvv.
> 
> Yes, it does:
>     lspci -vvv -s 03:00 | grep Serial
>         Capabilities: [140 v1] Device Serial Number [...]
> 

OK, I got it, thanks!

> 
> Paul Bolle
> 
> 
> 


-- 
Thanks!
Yijing

