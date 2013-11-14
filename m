Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754637Ab3KNPnh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 10:43:37 -0500
Received: from mailout1.w2.samsung.com ([211.189.100.11]:42872 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab3KNPna (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 10:43:30 -0500
X-AuditID: cbfec37a-b7fb76d000006e93-a1-5284efa1b154
Message-id: <5284EF9F.5050508@samsung.com>
Date: Thu, 14 Nov 2013 08:43:27 -0700
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101
 Thunderbird/24.1.0
MIME-version: 1.0
To: gregkh@linuxfoundation.org, rjw@rjwysocki.net
Cc: Shuah Khan <shuah.kh@samsung.com>, shuahkhan@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] Add Legacy PM OPS usage checks to class, bus,
 and driver register functions
References: <cover.1383868060.git.shuah.kh@samsung.com>
In-reply-to: <cover.1383868060.git.shuah.kh@samsung.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrOLMWRmVeSWpSXmKPExsVy+t9hP92F71uCDK5+N7RoXryezeLyrjls
	FmdOX2K1+PrTwYHFY+esu+we++euYffYcrWdxePzJrkAligum5TUnMyy1CJ9uwSujMPz7Aoe
	cVVs2fKfsYFxF0cXIyeHhICJxNkvU1ggbDGJC/fWs3UxcnEICSxjlGid8BLK6WWSWPxpOwuE
	s4lR4trxE2wgLbwCWhI9XbvZQWwWAVWJFdvmMILYbALqEp9f7wCLCwnISTQtWc0MYosKREgc
	Xf2MFaJXUOLH5Htgq0UEDCVen/gFVMPBwSwQJTGnWRjEFBZIk7iwLwZiirnExj13wSZyClhI
	zFt8DMxmFrCWWDlpGyOELS+xec1bZoh6ZYk/l08xgYyREFCU2L7aagKjyCwke2ch6Z6FpHsB
	I/MqRrHS4uSC4qT01ApDveLE3OLSvHS95PzcTYyQyKjawXjnq80hRgEORiUe3sKdzUFCrIll
	xZW5hxglOJiVRHj/328JEuJNSaysSi3Kjy8qzUktPsTIxMEp1cDYfXHPAf/ikok87/4f3Xvm
	mmV1/8Z07cuzc+VquQP+ndb9Jmt1TbzhPP+skxdlJnF4TTbefPtxTxffpgLRRRkGn1+eCN1T
	pLDhqqfE8t07UvTYcybP3LaWZdlOA9sfifN2+hRMELDyfnNqvw/X3MDuG2fd56rF9QlYrxL2
	C4z9zjnrz3O95dU7lFiKMxINtZiLihMBfzdeX2oCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 05:03 PM, Shuah Khan wrote:
> Add Legacy PM OPS usage checks to class, bus, and driver register functions.
> If Legacy PM OPS usage is found, print warning message to indicate the driver
> code needs updating to use Dev PM OPS interfaces. This will help serve as a way
> to track drivers that still use Legacy PM OPS and fix them.
>
> This patch set adds Legacy PM OPS usage check and warning to bus_register(),
> __class_register(), and driver_register() functions.
>
> Individual patches in this series are not dependent on each other. The only
> reason this is a series is for context and facilitating discussion on the
> overall change as opposed individual patches.
>
> Shuah Khan (3):
>    drivers/bus: Add Legacy PM OPS usage check and warning to
>      bus_register()
>    drivers/class: Add Legacy PM OPS usage check and warning to
>      __class_register()
>    driver: Add Legacy PM OPS usage check and warning to driver_register()
>
>   drivers/base/bus.c    | 3 +++
>   drivers/base/class.c  | 4 ++++
>   drivers/base/driver.c | 4 ++++
>   3 files changed, 11 insertions(+)
>

Greg/Rafael,

Any feedback on this series? Haven't gotten to it or don't like it?

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
