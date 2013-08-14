Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759227Ab3HNPfm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 11:35:42 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:36346 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014Ab3HNPfl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 11:35:41 -0400
X-AuditID: cbfec7f5-b7f5f6d00000105f-3b-520ba3cb9513
Message-id: <520BA3C9.8050606@samsung.com>
Date: Wed, 14 Aug 2013 17:35:37 +0200
From: Andrzej Hajda <a.hajda@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: lee.jones@linaro.org
Cc: Andrzej Hajda <a.hajda@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-media@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Seung-Woo Kim <sw0312.kim@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH RFC v2 1/2] max77693: added device tree support
References: <1361288177-14452-1-git-send-email-a.hajda@samsung.com>
 <1361288177-14452-2-git-send-email-a.hajda@samsung.com>
 <20130408152122.GU24058@zurbaran> <51E64BA8.30205@samsung.com>
In-reply-to: <51E64BA8.30205@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsVy+t/xK7qnF3MHGcz4wmVxa905VosDsx+y
	WpxtesNucf/rUUaLy7vmsFn0bNjKanH4TTurxeluVosZk1+yOXB63Lm2h81j3slAj/MzFjJ6
	9G1ZxejxeZNcAGsUl01Kak5mWWqRvl0CV8aCdTNZC3q5KuadX8/cwDiFo4uRk0NCwERiy+kW
	RghbTOLCvfVsXYxcHEICSxklPm3azAzhfGKUePr1KCtIFa+AlsS3W4eBbA4OFgFViXn3/UHC
	bAKaEn8332QDsUUFIiRWLnkAVS4o8WPyPRYQW0RAQmLjjz4WkJnMAluZJDbM7GcHSQgLOEtc
	mjqTFWLZPkaJ+89fgSU4gaaevbYabBKzgI7E/tZpbBC2vMTmNW+ZJzAKzEKyZBaSsllIyhYw
	Mq9iFE0tTS4oTkrPNdIrTswtLs1L10vOz93ECAn8rzsYlx6zOsQowMGoxMMb0cYdJMSaWFZc
	mXuIUYKDWUmE90wHUIg3JbGyKrUoP76oNCe1+BAjEwenVAPjfKGiTQIv9Wc/27OMzz6U/fuU
	jdsPpLZPr+bynsXdr/byR9LJlzYi889a3+F7kznDJOpBl26755qH75piV8xrLmcvSe1+3GGz
	p1oz3sTC3P3+dg6BizNrF6X81G5tjzdhub1gvX7D/lzRlpWn9H8mpOx2K3t6MoHjcG0Bc8je
	nBSFhiVylQZKLMUZiYZazEXFiQCyxPfGWgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lee,

I have no response from Samuel regarding this patch.
Could you take care of it, I can rebase it again if necessary.

Regards
Andrzej

On 07/17/2013 09:45 AM, Andrzej Hajda wrote:
> Hi Samuel,
>
> A while ago I have send rebased patch adding device-tree support for
> max77693 as you asked:
> https://patchwork.kernel.org/patch/2414341/
>
> The patch is still not applied. Is there a reason for that or just an
> omission?
>
> Regards
> Andrzej
>
> On 04/08/2013 05:21 PM, Samuel Ortiz wrote:
>> Hi Andrzej,
>>
>> On Tue, Feb 19, 2013 at 04:36:16PM +0100, Andrzej Hajda wrote:
>>> max77693 mfd main device uses only wakeup field
>>> from max77693_platform_data. This field is mapped
>>> to wakeup-source property in device tree.
>>> Device tree bindings doc will be added in max77693-led patch.
>>>
>>> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
>>> Reviewed-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
>>> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
>>> ---
>>>  drivers/mfd/max77693.c |   40 +++++++++++++++++++++++++++++++++-------
>>>  1 file changed, 33 insertions(+), 7 deletions(-)
>> This patch looks good to me, but doesn't apply to mfd-next. Would you mind
>> rebasing it ?
>>
>> Cheers,
>> Samuel.
>>
>>

