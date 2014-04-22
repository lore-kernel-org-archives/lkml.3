Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757012AbaDVPa2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:30:28 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:60283 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756974AbaDVPaU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:30:20 -0400
Message-ID: <53568B04.4050703@ti.com>
Date: Tue, 22 Apr 2014 21:00:12 +0530
From: Balaji T K <balajitk@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <chris@printf.net>, <ulf.hansson@linaro.org>, <linux-mmc@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] mmc: host: omap_hsmmc: a few improvements
References: <1395878690-9650-1-git-send-email-balbi@ti.com> <20140421173203.GH22794@saruman.home>
In-Reply-To: <20140421173203.GH22794@saruman.home>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 April 2014 11:02 PM, Felipe Balbi wrote:
> Hi,
>
> On Wed, Mar 26, 2014 at 07:04:45PM -0500, Felipe Balbi wrote:
>> this series lets us access the newer registers introduced
>> back in OMAP4 which give us some valid information about
>> the OMAP HSMMC IP like max block size, support for ADMA,
>> support for Retention.
>>
>> Right now, only setting max_blk_size correctly as supporting
>> ADMA and Retention will take a lot of work.
>>
>> Tested on OMAP5 uEVM.
>>
>> Felipe Balbi (5):
>>    mmc: host: omap_hsmmc: pass host as an argument
>>    mmc: host: omap_hsmmc: add reg_offset field
>>    mmc: host: omap_hsmmc: introduce new accessor functions
>>    mmc: host: omap_hsmmc: switch over to new accessors
>>    mmc: host: omap_hsmmc: set max_blk_size correctly

Got mislead by your reply to this series, about the alternative way of
reading memory size from CAPA register

>
> this has been here for almost a month, any comments ?
>

Do you see any performance impact with this series ?
