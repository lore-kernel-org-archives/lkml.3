Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750924AbaGJFLb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:11:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:50645 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750702AbaGJFL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:11:29 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfee68f-b7fef6d000003970-e8-53be207ab8cb
Content-transfer-encoding: 8BIT
Message-id: <53BE207A.8020800@samsung.com>
Date: Thu, 10 Jul 2014 14:11:22 +0900
From: Joonyoung Shim <jy0922.shim@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101
 Thunderbird/24.2.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sachin Kamat <spk.linux@gmail.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mark Brown <broonie@linaro.org>, tobetter@gmail.com
Subject: Re: [PATCH 1/3] usb: usb3503: fix build warning
References: <1404966228-29133-1-git-send-email-jy0922.shim@samsung.com>
 <CAK5sBcFKOc-_aGuC8QQu_NHc67AfZGz0MUeURqVr8P6K3Zzzmg@mail.gmail.com>
 <20140710050539.GD14064@kroah.com>
In-reply-to: <20140710050539.GD14064@kroah.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrDIsWRmVeSWpSXmKPExsWyRsSkULdKYV+wQfM8Q4tN16+zWjQvXs9m
	cXnXHDaLRctamS3WHrnLbtHy9RyLxb7Ha5gd2D12zrrL7nHn2h42j/1z17B79G1ZxejxeZNc
	AGsUl01Kak5mWWqRvl0CV8bZrf+YCyaxV5w73cHWwPiJtYuRk0NCwETiYsMENghbTOLCvfVg
	tpDAUkaJa/dZYGqeXNrA1MXIBRRfxCjRua4TrIhXQFDix+R7QEUcHMwC8hJHLmWDhJkF1CUm
	zVvEDDHnFaPE5Xe8ICW8AloSs9bpgYRZBFQl3h36zwhiswnoSdzZdpwJxBYVCJOYeuIq2FoR
	gUiJzf3HWEHWMgucYJR4cmEJWJGwgIXEg8ePmCHu2cwocf1mF9gyTgF9ib0vdrCDJCQErrFL
	3O/7zgixTkDi2+RDYIdKCMhKbDrADPGYpMTBFTdYJjCKzULyziyEd2YheWcBI/MqRtHUguSC
	4qT0ImO94sTc4tK8dL3k/NxNjMCYO/3vWf8OxrsHrA8xJgNtnMgsJZqcD4zZvJJ4Q2MzIwtT
	E1NjI3NLM9KElcR57z9MChISSE8sSc1OTS1ILYovKs1JLT7EyMTBKdXAqB3K6iIiXqjgZLzl
	meKjswJVa24ZznB3dVh8O5iz8qtYymHDkJMfjqi9na2eomm5a2b6TektydsSNojX2Z4L1rmY
	ObXpjBCzvXKlpYhy2vWN9YvPf02LqZ3zI43TokM033rmmR/5DZfnB54S8bOZf7Py/QYfCfde
	oU3RZZkPblv7bnGqWlajxFKckWioxVxUnAgAKHtZic8CAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrDIsWRmVeSWpSXmKPExsVy+t9jAd0qhX3BBs+Wallsun6d1aJ58Xo2
	i8u75rBZLFrWymyx9shddouWr+dYLPY9XsPswO6xc9Zddo871/aweeyfu4bdo2/LKkaPz5vk
	AlijGhhtMlITU1KLFFLzkvNTMvPSbZW8g+Od403NDAx1DS0tzJUU8hJzU22VXHwCdN0yc4Du
	UFIoS8wpBQoFJBYXK+nbYZoQGuKmawHTGKHrGxIE12NkgAYS1jBmnN36j7lgEnvFudMdbA2M
	n1i7GDk5JARMJJ5c2sAEYYtJXLi3nq2LkYtDSGARo0Tnuk42kASvgKDEj8n3WLoYOTiYBeQl
	jlzKBgkzC6hLTJq3iBnEFhJ4xShx+R0vSAmvgJbErHV6IGEWAVWJd4f+M4LYbAJ6Ene2HQdb
	JSoQJjH1xFUWEFtEIFJic/8xVpC1zAInGCWeXFgCViQsYCHx4PEjZoh7NjNKXL/ZBbaMU0Bf
	Yu+LHewTGAVmITlvFsJ5s5Cct4CReRWjaGpBckFxUnqukV5xYm5xaV66XnJ+7iZGcEw/k97B
	uKrB4hCjAAejEg9vQ8/eYCHWxLLiytxDjBIczEoivB7/gUK8KYmVValF+fFFpTmpxYcYTYHe
	m8gsJZqcD0w3eSXxhsYmZkaWRuaGFkbG5krivAdbrQOFBNITS1KzU1MLUotg+pg4OKUaGCes
	ihZnamVcILLU5Jhzze2Kk1u43s2tquB/3XuaR3zLRMFvFxV2lllKx/G4tZ+qPHStWszq+ea9
	0heyZ6Q5H3x42swq4EtZe4LusknsIjfKRBZHWh496uf3OmnereT2apNlPy1tDTplpU1Z3afk
	zPHiutUrHbSX8XL9BW7++bV9IodKeRrClViKMxINtZiLihMB+xXtUv8CAAA=
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2014 02:05 PM, Greg Kroah-Hartman wrote:
> On Thu, Jul 10, 2014 at 10:22:46AM +0530, Sachin Kamat wrote:
>> Hi Joonyoung,
>>
>> On Thu, Jul 10, 2014 at 9:53 AM, Joonyoung Shim <jy0922.shim@samsung.com> wrote:
>>> This fixes below build warning.
>>>
>>> drivers/usb/misc/usb3503.c: In function ‘usb3503_probe’:
>>> drivers/usb/misc/usb3503.c:195:11: warning: ‘err’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>>>     dev_err(dev, "unable to request refclk (%d)\n", err);
>>>            ^
>>
>> This has been fixed and availabe in Greg's usb-next tree.
>> https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git/commit/?h=usb-next&id=ec5734c41bee2ee7c938a8f34853d31cada7e67a
> 
> Yes, Joonyoung, can you refresh this against my latest tree and resend
> anything that is still needed in this series?
> 

Aha, i missed it, ok i will resend.

Thanks.

