Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3H2Czy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 22:55:54 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:41617 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755610Ab3H2Czx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 22:55:53 -0400
Message-ID: <521EB7FB.6010004@huawei.com>
Date: Thu, 29 Aug 2013 10:54:51 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: <balbi@ti.com>, <stern@rowland.harvard.edu>,
        USB <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/4] usb: r8a66597-hcd: use platform_{get,set}_drvdata()
References: <521C5EEE.1080505@huawei.com> <20130828043607.GA21756@kroah.com>
In-Reply-To: <20130828043607.GA21756@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013/8/28 12:36, Greg KH wrote:
> On Tue, Aug 27, 2013 at 04:10:22PM +0800, Libo Chen wrote:
>>
>> Use the wrapper functions for getting and setting the driver data using
>> platform_device instead of using dev_{get,set}_drvdata() with &pdev->dev,
>> so we can directly pass a struct platform_device.
>>
>> Signed-off-by: Libo Chen <libo.chen@huawei.com>
>> ---
>>  drivers/usb/host/r8a66597-hcd.c |    4 ++--
>>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> This patch doesn't apply to my tree :(

Hi Greg,

This patch based on mainline.
Do you mean this patch got a conflicted in "git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git"

I need to rebase on "usb.git"?


> 
> 
> 


