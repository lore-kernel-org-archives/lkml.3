Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754388AbaE3BWh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 21:22:37 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:45204 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900AbaE3BWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 21:22:36 -0400
X-AuditID: cbfee68d-b7fd46d000005f36-c9-5387dd4f9028
Message-id: <5387DD70.6070302@samsung.com>
Date: Fri, 30 May 2014 10:22:56 +0900
From: Heesub Shin <heesub.shin@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.4.0
MIME-version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Sunghwan Yun <sunghwan.yun@samsung.com>,
        Daeseok Youn <daeseok.youn@gmail.com>, linux-kernel@vger.kernel.org,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        Dongjun Shin <d.j.shin@samsung.com>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Rebecca Schultz Zavin <rebecca@android.com>
Subject: Re: [PATCH v2 1/9] staging: ion: tidy up a bit
References: <1401098701-24049-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-1-git-send-email-heesub.shin@samsung.com>
 <1401259980-26927-2-git-send-email-heesub.shin@samsung.com>
 <20140529204208.GA2120@kroah.com>
In-reply-to: <20140529204208.GA2120@kroah.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBIsWRmVeSWpSXmKPExsVy+t8zXV3/u+3BBusvq1q8/3ufzWL7xm+s
	Ficu1loc/HCfxWLPmV/sFs2L17NZHJy9hMnizG9di8u75rBZ3JhcaHG6YxGrA7fHtt3bWD3u
	7TvM4rFz1l12jzvX9rB57J+7ht2jb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4MibMfc5WcJK1
	Yv7zdsYGxqMsXYycHBICJhK/t/9lhrDFJC7cW88GYgsJLGOUeLNBAKbm4M91jBDxRYwSv1Ya
	djFyAdlvGCUmL7oHluAV0JJYsO8DO4jNIqAq8XbFT6ChHBxsAtoSh7YFg4RFBSIk7jUeZoUo
	F5T4Mfke2A0iAsYS/WdnsYPMZBZ4xiSx/+YksF5hAXOJx5/lIXY9Z5RY9H8uWDOngJ7E7jNb
	wPYyC1hLrJy0DcqWl9i85i0zSIOEwE92ie6pTWwQBwlIfJt8iAVkqISArMSmA1APS0ocXHGD
	ZQKj2CwkN81CMnYWkrELGJlXMYqmFiQXFCelFxnqFSfmFpfmpesl5+duYoTEau8OxtsHrA8x
	JgOtnMgsJZqcD4z1vJJ4Q2MzIwtTE1NjI3NLM9KElcR5kx4mBQkJpCeWpGanphakFsUXleak
	Fh9iZOLglGpg7EguzswOMDG/Wn6o5OV/Oa2N196+OWLar2v+Z8ftjo514VOfvF349nSU8pY6
	IfNHzAoF16P/ViWVCL/n4Iqfyj7TVbZ24tOH7Vs8O/ob3gj8Ol/d9niZgcGRr4Jab3wakoKa
	+srjDn62DuKddm+p5YedhvwNPmlRy6+JLpPzErQ+bn4/cWKcEktxRqKhFnNRcSIAKw9KSOsC	AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGKsWRmVeSWpSXmKPExsVy+t9jAV3/u+3BBg/WKFq8/3ufzWL7xm+s
	Ficu1loc/HCfxWLPmV/sFs2L17NZHJy9hMnizG9di8u75rBZ3JhcaHG6YxGrA7fHtt3bWD3u
	7TvM4rFz1l12jzvX9rB57J+7ht2jb8sqRo/Pm+QC2KMaGG0yUhNTUosUUvOS81My89JtlbyD
	453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJzgE5UUihLzCkFCgUkFhcr6dthmhAa4qZrAdMY
	oesbEgTXY2SABhLWMWZMmPucreAka8X85+2MDYxHWboYOTkkBEwkDv5cxwhhi0lcuLeeDcQW
	EljEKPFrpWEXIxeQ/YZRYvKie2BFvAJaEgv2fWAHsVkEVCXervjJ3MXIwcEmoC1xaFswSFhU
	IELiXuNhVohyQYkfk++B7RIRMJboPzuLHWQms8AzJon9NyeB9QoLmEs8/iwPses5o8Si/3PB
	mjkF9CR2n9kCtpdZwFpi5aRtULa8xOY1b5knMArMQrJjFpKyWUjKFjAyr2IUTS1ILihOSs81
	0itOzC0uzUvXS87P3cQITgXPpHcwrmqwOMQowMGoxMM7Ib09WIg1say4MvcQowQHs5IIr+Nh
	oBBvSmJlVWpRfnxRaU5q8SHGZGAITGSWEk3OB6apvJJ4Q2MTMyNLIzNjE3NjY9KElcR5D7Za
	BwoJpCeWpGanphakFsFsYeLglGpgNNr8SD1r849PUgvNi43l2bMzDqzSyqlRcEo5tMOra9H+
	DBZeU4Xok5zsXbtDm939/th9mqpcOXnmvIViJ6QflT/+wdZ+77pQ0vJXp5dfO7B12Q7+tGXz
	LyT8y2/ia/5z4GHBD+7MDR83TPzd0F9heUZqTY7K7G9unx/pi6741jFtcty3ZV3dgkosxRmJ
	hlrMRcWJAHAcIitJAwAA
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 05/30/2014 05:42 AM, Greg Kroah-Hartman wrote:
> On Wed, May 28, 2014 at 03:52:52PM +0900, Heesub Shin wrote:
>> For aesthetics and readability, rename goto labels, remove
>> useless code lines, and clarify function return type.
>>
>> Signed-off-by: Heesub Shin <heesub.shin@samsung.com>
>> Reviewed-by: Mitchel Humpherys <mitchelh@codeaurora.org>
>> Tested-by: John Stultz <john.stultz@linaro.org>
>
> Not all of these would apply to my tree.  So I've applied the ones that
> did.  Please resend the remaining ones, after refreshing them against my
> staging-next branch of the staging.git tree.

Hi KH,

I will rebase them on staging-next and resend soon.

Thanks a lot!

regads,
heesub
