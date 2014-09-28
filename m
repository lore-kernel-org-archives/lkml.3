Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753532AbaI1IyE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Sep 2014 04:54:04 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:56387 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750989AbaI1IyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Sep 2014 04:54:02 -0400
Message-ID: <5427CCA4.6060909@codeaurora.org>
Date: Sun, 28 Sep 2014 11:53:56 +0300
From: Tanya Brokhman <tlinder@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Richard Weinberger <richard.weinberger@gmail.com>
CC: Artem Bityutskiy <dedekind1@gmail.com>, linux-arm-msm@vger.kernel.org,
        Pratibhasagar V <pratibha@codeaurora.org>,
        open list <linux-kernel@vger.kernel.org>, dedeking1@gmail.com,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Brian Norris <computersforpeace@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>
Subject: Re: [RFC/PATCH 5/5] mtd: ubi: Add sysfs entry to force all pebs'
 scan
References: <1411886287-8947-1-git-send-email-tlinder@codeaurora.org> <CAFLxGvz5RXmC3vuCWkNSiAn91j6dC_9Q9XF3njObb_jBbL-ohw@mail.gmail.com>
In-Reply-To: <CAFLxGvz5RXmC3vuCWkNSiAn91j6dC_9Q9XF3njObb_jBbL-ohw@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/28/2014 11:42 AM, Richard Weinberger wrote:
> Tanya,
>
> On Sun, Sep 28, 2014 at 8:38 AM, Tanya Brokhman <tlinder@codeaurora.org> wrote:
>> A given eraseblock can be read many times or not at all.
>> We do not have the account of such eraseblocks that have
>> not been accessed since a pre-defined threshold interval.
>> By means of scanning the entire flash device it is possible to identify
>> all such eraseblocks.
>>
>> Add a sysfs entry to force scan on all the PEBs on demand basis.
>>
>> The sysfs entry would be available under /sys/class/ubi/ubiX/peb_scan
>>   - echo 1 to this entry would trigger the scan, ignored if in progress
>>   - On reading returns the scan status (1 = Scan executing, 0 = Scan not
>>     executing)
>
> Did you see that?
> http://linux-kernel.2935.n7.nabble.com/RFC-UBI-bitrot-checking-td949453.html
> Maybe we can combine our work.
> Although your patch seems to be in better shape than mine. :)

oh, I'm sorry, missed that (its new :) )
this patch was tested thoroughly and working. I would appreciate if you 
could review this patch and perhaps we could improve it if required.


-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, 
hosted by The Linux Foundation
