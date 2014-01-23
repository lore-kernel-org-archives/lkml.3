Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaAWKVM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 05:21:12 -0500
Received: from mailout4.w1.samsung.com ([210.118.77.14]:51751 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753153AbaAWKVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 05:21:09 -0500
X-AuditID: cbfec7f5-b7fc96d000004885-49-52e0ed125e87
Message-id: <52E0ED10.2020901@samsung.com>
Date: Thu, 23 Jan 2014 11:21:04 +0100
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.1
MIME-version: 1.0
To: "'Amit Grover'" <amit.grover@samsung.com>, m.chehab@samsung.com,
        linux-media@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, rob@landley.net,
        kyungmin.park@samsung.com, jtp.park@samsung.com
Cc: Kamil Debski <k.debski@samsung.com>, hans.verkuil@cisco.com,
        andrew.smirnov@gmail.com, arun.kk@samsung.com,
        anatol.pomozov@gmail.com, jmccrohan@gmail.com, austin.lobo@samsung.com,
        "'Swami Nathan'" <swaminath.p@samsung.com>
Subject: Re: [PATCH] [media] s5p-mfc: Add Horizontal and Vertical search range
 for Video Macro Blocks
References: <1388400186-22045-1-git-send-email-amit.grover@samsung.com>
 <019f01cf1823$7e020fa0$7a062ee0$%debski@samsung.com>
In-reply-to: <019f01cf1823$7e020fa0$7a062ee0$%debski@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrBLMWRmVeSWpSXmKPExsVy+t/xa7pCbx8EGbxeoG/xrO8Tq8XL3kKL
	5g5bi4+nbrNazP90k8Viyc9dTBb9j9YzWhxZe5XJ4sfrC2wWZ5vesFtsenyN1WJh2xIWi8u7
	5rBZ9GzYymox4/w+JouL6+Qt1r2czmLR1jWV0UHIY8rvjaweO2fdZfd4tXomq8fmJfUefVtW
	MXp83iQXwBbFZZOSmpNZllqkb5fAlfGh+wl7wUS2indnFjM3MDazdjFyckgImEisOfiTEcIW
	k7hwbz1bFyMXh5DAUkaJCd9WsEI4nxglXh5ZxQJSxSugJdH55T0TiM0ioCrR86ODGcRmEzCU
	6D3aBzZJVCBC4u+89YwQ9YISPybfYwEZJCKwikni/ulZYCuYBZ4xSjze3gBWJSyQLvH/7xEw
	W0igTuL62ctgGzgFHCU2HtjLDmIzC+hI7G+dxgZhy0tsXvOWeQKjwCwkS2YhKZuFpGwBI/Mq
	RtHU0uSC4qT0XCO94sTc4tK8dL3k/NxNjJDY+rqDcekxq0OMAhyMSjy8iV/uBwmxJpYVV+Ye
	YpTgYFYS4b344kGQEG9KYmVValF+fFFpTmrxIUYmDk6pBsZzfMaLnCMX1W0tdVwx+UfSjAMJ
	59am9UZ9DmcrP7B7tv/ZMIU/quuKeGZ/SkmPdH2rfTVWoOPHkfmbHv/OW7Jqe2zp7s1bFa+a
	fLqg9VQs+8esW1a71ScvEBVhXyx6+cKJU9z5Vz5l6Kl9yfstv/fdiegnrc3CARMKJp5XZ7dw
	LDv4896umAcWSizFGYmGWsxFxYkADc1Sz4sCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 23/01/14 11:11, Kamil Debski wrote:
>> diff --git a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> > b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> > index 4ff3b6c..a02e7b8 100644
>> > --- a/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> > +++ b/drivers/media/platform/s5p-mfc/s5p_mfc_enc.c
>> > @@ -208,6 +208,24 @@ static struct mfc_control controls[] = {
>> >  		.default_value = 0,
>> >  	},
>> >  	{
>> > +		.id = V4L2_CID_MPEG_VIDEO_HORZ_SEARCH_RANGE,
>> > +		.type = V4L2_CTRL_TYPE_INTEGER,
>> > +		.name = "horizontal search range of video macro block",
>
> This too should be property capitalised. Please mention the motion vectors
> too. 

And additionally length of the name string should not exceed 31 characters.

--
Thanks,
Sylwester
