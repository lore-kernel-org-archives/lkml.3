Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350AbaI2Gze (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 02:55:34 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:42276 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751335AbaI2Gzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 02:55:33 -0400
Message-ID: <542903B1.1000601@gmail.com>
Date: Mon, 29 Sep 2014 15:01:05 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
CC: Michal Simek <michal.simek@xilinx.com>, monstr@monstr.eu,
        linux-usb@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] drivers/usb/host/ehci-xilinx-of.c: Include "linux/of_irq.h"
 to avoid compiling error
References: <e0dec78e-193e-43ee-bdb0-fa776a6dd044@BY2FFO11FD030.protection.gbl> <Pine.LNX.4.44L0.1409241141260.1580-100000@iolanthe.rowland.org> <20140929015224.GB27008@kroah.com>
In-Reply-To: <20140929015224.GB27008@kroah.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/29/14 9:52, Greg Kroah-Hartman wrote:
> On Wed, Sep 24, 2014 at 11:41:55AM -0400, Alan Stern wrote:
>> On Mon, 22 Sep 2014, Michal Simek wrote:
>>
>>> Alan: Can you please add this patch to your queue?
>>> Greg: If Alan is not maintaining this part of kernel, is this patch in your queue?
>>>
>>> I have also not a problem to add this patch through my microblaze tree
>>> but I think it will be much better to use any USB tree.
>>
>> Greg should be able to accept a trivial patch like this one directly.
> 
> I can, if someone will resend it so I can apply it :)
> 

This patch you have already applied (applied this patch in 2014-09-24),
so I need not resend it.

Thank all of you for your work.

Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
