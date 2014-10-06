Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632AbaJFJex (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 05:34:53 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:15228 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751720AbaJFJew (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 05:34:52 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-92-5432623973d6
Message-id: <54326223.3050201@samsung.com>
Date: Mon, 06 Oct 2014 11:34:27 +0200
From: Sylwester Nawrocki <s.nawrocki@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Kyungmin Park <kyungmin.park@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Valentin Rothberg <valentinrothberg@gmail.com>
Subject: Re: [PATCH 3/4] [media] Remove optional dependency on PLAT_S5P
References: <1412586626.4054.42.camel@x220> <4788945.SoI4OqN9Zu@wuerfel>
In-reply-to: <4788945.SoI4OqN9Zu@wuerfel>
Content-type: text/plain; charset=windows-1252
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsVy+t/xy7qWSUYhBn8OyFv8nXSM3eJs0xt2
	i02Pr7FaXN41h82iZ8NWVouL6+QtFt06w2zxqbmN2YHD4/evSYweO2fdZffYvKTeo2/LKkaP
	jdufMHl83iQXwBbFZZOSmpNZllqkb5fAlbHp5Tumgn62ii8LZjE3MB5i6WLk5JAQMJG4MnMe
	E4QtJnHh3nq2LkYuDiGBpYwS9152MkI4nxglnh+9DNTBwcEroCXReAusmUVAVWLFl6lgzWwC
	hhK9R/sYQWxRgQiJk3f3sIPYvAKCEj8m3wOrFxFwl1g3fR4ryExmgdeMEqfWPAcrEgZKPGr4
	BNYsJOAhseHrS3aQXZwCmhJrD6qAmMwCehL3L2qBVDALyEtsXvOWeQKjwCwkG2YhVM1CUrWA
	kXkVo2hqaXJBcVJ6rqFecWJucWleul5yfu4mRkjAf9nBuPiY1SFGAQ5GJR7eiB2GIUKsiWXF
	lbmHGCU4mJVEeL0SjUKEeFMSK6tSi/Lji0pzUosPMTJxcEo1MM6udm+1PLCdQe2AbPEhD8aw
	z9vTbI51Mb11UHvvMHehpfOz2zYnrjnuYwr6t//JqmWGTzi47ywtmTrje8QeVyUhHfnkjRvX
	ZBzyW3RRuk4/Z1/IZTbb51o5gqlXlRTKvxRXHxJdl9cksfnQFMkNHrsPFvKLR/n8+Mznu37/
	jKqzFa3mxg/MPZVYijMSDbWYi4oTAYTQBhBWAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/14 11:26, Arnd Bergmann wrote:
> On Monday 06 October 2014 11:10:26 Paul Bolle wrote:
>>  config VIDEO_SAMSUNG_S5P_TV
>>         bool "Samsung TV driver for S5P platform"
>>         depends on PM_RUNTIME
>> -       depends on PLAT_S5P || ARCH_EXYNOS || COMPILE_TEST
>> +       depends on ARCH_EXYNOS || COMPILE_TEST
>>         default n
>>         ---help---
>>           Say Y here to enable selecting the TV output devices for
>>
> 
> I wonder if it should now allow being built for ARCH_S5PV210.
> Maybe it was a mistake to remove the PLAT_S5P symbol without changing
> the use here?
> 
> Does S5PV210 have this device?

Yes, it does. Indeed, in all patches in this series we should
have replaced PLAT_S5P with ARCH_S5PV210.

--
Thanks,
Sylwester
