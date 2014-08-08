Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbaHHGnW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 02:43:22 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:8255 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752831AbaHHGnR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 02:43:17 -0400
X-AuditID: cbfec7f5-b7f776d000003e54-57-53e471813b96
Message-id: <53E47186.5000309@samsung.com>
Date: Fri, 08 Aug 2014 08:43:18 +0200
From: Jacek Anaszewski <j.anaszewski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130804
 Thunderbird/17.0.8
MIME-version: 1.0
To: Bryan Wu <cooloney@gmail.com>
Cc: Linux LED Subsystem <linux-leds@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Kyungmin Park <kyungmin.park@samsung.com>, b.zolnierkie@samsung.com
Subject: Re: [PATCH/RFC v4 00/21] LED / flash API integration
References: <1405087464-13762-1-git-send-email-j.anaszewski@samsung.com>
 <CAK5ve-L67=q-EpWvxD5-x+cFT7dh8p0HHuoUbAWA-j5BqCO52A@mail.gmail.com>
 <CAK5ve-+xyXyjPqejTPRvz=bJ4M5v19Uq1oaVv94QKqBWf1D4dA@mail.gmail.com>
In-reply-to: <CAK5ve-+xyXyjPqejTPRvz=bJ4M5v19Uq1oaVv94QKqBWf1D4dA@mail.gmail.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xy7pNhU+CDX7lWGycsZ7V4ujOiUwW
	84+cY7U42/SG3eLyrjlsFlvfrGO06NmwldWB3WPnrLvsHn1bVjF6fN4kF8AcxWWTkpqTWZZa
	pG+XwJWx59lf1oJJXBW/HnxhbWCcztHFyMkhIWAicf7HVlYIW0ziwr31bF2MXBxCAksZJW58
	/MII4XxklNj8eQMzSBWvgJbExbPrWEBsFgFViceHv4LF2QQMJX6+eM0EYosKREj8Ob2PFaJe
	UOLH5Htg9SICihIL3+xnAhnKLDCPSWLrottgDcICthK/ruxjh9h2jVHi89oLbCAJToFgiScz
	/4BtYBYwk3jUsg7KlpfYvOYt8wRGgVlIlsxCUjYLSdkCRuZVjKKppckFxUnpuUZ6xYm5xaV5
	6XrJ+bmbGCFB/XUH49JjVocYBTgYlXh4FfbeDRZiTSwrrsw9xCjBwawkwlvz+XGwEG9KYmVV
	alF+fFFpTmrxIUYmDk6pBsbjKS3V4qV2+8un2TO4Ms6xOJ9ZaPnq4Lq6aPkn23/lebx6mpjD
	umZup9m7jh6rkB9u7/89yjHasFZZi9eTKYKx9cauM5+kYkrSFv04n+XxqUf2w9+MGR4CN1U2
	/fvOndsvN+OKi5MNp1ycLHfu35UVmmc/cP9dVblmTkC8lahy6lQTeX5rTSWW4oxEQy3mouJE
	ACeWC45IAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bryan,

On 07/16/2014 07:21 PM, Bryan Wu wrote:
> On Wed, Jul 16, 2014 at 10:19 AM, Bryan Wu <cooloney@gmail.com> wrote:
>> On Fri, Jul 11, 2014 at 7:04 AM, Jacek Anaszewski
>> <j.anaszewski@samsung.com> wrote:
>>> This is is the fourth version of the patch series being a follow up
>>> of the discussion on Media summit 2013-10-23, related to the
>>> LED / flash API integration (the notes from the discussion were
>>> enclosed in the message [1], paragraph 5).
>>> The series is based on linux-next-20140707
>>>
>>
>> I really apologize that I missed your discussion email in my Gmail
>> inbox, it was archived some where. Even in this series some of these
>> patches are archived in different tab.
>>
>> I will start to review and help to push this.
>>
>
> In the mean time, could you please provide an git tree for me to pull?
> It's much easier for me to review in my git.

Few days ago I sent to your private email the path to the git
repository to pull, but I am resending it through the lists to
make sure that it will not get filtered somehow again.

git://linuxtv.org/snawrocki/samsung.git
branch: led_flash_integration_v4

gitweb:
http://git.linuxtv.org/cgit.cgi/snawrocki/samsung.git/log/?h=led_flash_integration_v4

Best Regards,
Jacek Anaszewski
