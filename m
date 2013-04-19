Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967782Ab3DSBu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 21:50:56 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:52071 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967641Ab3DSBuz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 21:50:55 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID r3J1oWv2000481
Message-ID: <5170A2E9.1030704@realsil.com.cn>
Date: Fri, 19 Apr 2013 09:50:33 +0800
From: wwang <wei_wang@realsil.com.cn>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: <cjb@laptop.org>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>, <linux-mmc@vger.kernel.org>,
        <gregkh@linuxfoundation.org>, <rogerable@realtek.com>
Subject: Re: [PATCH v2] mfd:rtsx: Support RTS5249
References: <cover.1365648007.git.wei_wang@realsil.com.cn> <6b09b5138a549e49ea2d27bfee0e36c7aebb0a1b.1365648007.git.wei_wang@realsil.com.cn> <20130418225022.GF8798@zurbaran>
In-Reply-To: <20130418225022.GF8798@zurbaran>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [172.29.41.8]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

于 2013年04月19日 06:50, Samuel Ortiz 写道:
> Hi Wei,
>
> On Thu, Apr 11, 2013 at 10:43:40AM +0800, wei_wang@realsil.com.cn wrote:
>> From: Wei WANG <wei_wang@realsil.com.cn>
>>
>> Support new model: RTS5249
> Could you please provide me with a more detailled changelog (What's so
> different with this model that the current driver does not support ?) before I
> apply it ?
>
> Cheers,
> Samuel.
>

The difference is minor except that RTS5249 supports SD UHS-II interface.

In order to support SD UHS-II，the definitions of some internal 
registers of RTS5249 have to be modified and are different from its 
predecessors. So we need this patch to ensure RTS5249 can work, even 
SD/MMC stack doesn't support UHS-II interface.

