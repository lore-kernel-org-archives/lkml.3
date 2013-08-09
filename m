Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031232Ab3HIVdh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 17:33:37 -0400
Received: from mailout4.w2.samsung.com ([211.189.100.14]:60756 "EHLO
	usmailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031121Ab3HIVdf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 17:33:35 -0400
X-AuditID: cbfec37d-b7f036d000004805-25-5205602ef18c
From: Shuah Khan <shuah.kh@samsung.com>
To: David Brown <davidb@codeaurora.org>
Cc: "rpurdie@rpsys.net" <rpurdie@rpsys.net>,
        "FlorianSchandinat@gmx.de" <FlorianSchandinat@gmx.de>,
        "plagnioj@jcrosoft.com" <plagnioj@jcrosoft.com>,
        "tomi.valkeinen@ti.com" <tomi.valkeinen@ti.com>,
        "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [PATCH v2] backlight: Convert from Legacy pm ops to dev_pm_ops
Thread-topic: [PATCH v2] backlight: Convert from Legacy pm ops to dev_pm_ops
Thread-index: AQHOXntXl5mYvXa3VkiuDxQ5IdwjbQ==
Date: Fri, 09 Aug 2013 21:33:32 +0000
Message-id: <B8EFE96D1287C24090BAD9D858E15E617624BE@sisaex02sj>
References: <2236505237-3336-1-git-send-email-shuah.kh@samsung.com>
 <20130809212805.GA4987@codeaurora.org>
Accept-Language: en-US
Content-language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
X-Originating-IP: [105.144.21.63]
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 8BIT
MIME-version: 1.0
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrNIsWRmVeSWpSXmKPExsVy+t9hP129BNYgg/nLeS0eL//HZtE58xqj
	xYm+D6wWl3fNYbNY9/AFk8XjFW/ZLXbvespq8fWng8X6+bfYHDg9Lvf1MnnsnHWX3ePDxziP
	xXteMnm8unCHxWPP/B+sHsdvbGfy+LxJLoAjissmJTUnsyy1SN8ugStj5rqXjAUfWStOvt/I
	0sD4mKWLkZNDQsBEYuH7qUwQtpjEhXvr2boYuTiEBJYxSjw4+Y0VwullknjXf5ARwpnPKLGu
	fRY7SAubgLrE59c7wGwRIPvu01fsIEXMAjeZJRZOewGWEBbwlug4s4YJoshH4ujvVawQtp7E
	xYVbGEFsFgFVieVzZoDZvAL2EnvanoLVCwnkSKzubgarZwS67/spiDnMAuISza03oX4QkFiy
	5zwzhC0q8fLxP6B6DiBbUWL7aiuIci2J9TuPQ7VqSzx5d4EVYpWgxI/J91gmMIrNQjJ1FpKW
	WUhaZiFpWcDIsopRrLQ4uaA4KT21wkSvODG3uDQvXS85P3cTIySCa3cw3v9qc4hRgINRiYd3
	wi+WICHWxLLiytxDjBIczEoivN2RrEFCvCmJlVWpRfnxRaU5qcWHGJk4OKUaGFdymz185spz
	15A54NKFbdPZjuS9vGdz9Y5C5ee/q2Pu8ghUWCbNjxS/NydRdw2P0b3bBnv0Vjw3ccw4sH5T
	4EtXxQ/rp+75e6N95sagf/9zn3dFKclmXPAJeb1lS3PqJya+y78SqqxyH5owCKZZNbKXzajQ
	FOyV+Jb7sfM565a//3NPpOf1LFBiKc5INNRiLipOBACGgJRdvgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2013 03:28 PM, David Brown wrote:
> On Wed, Nov 14, 2040 at 04:27:17AM -0700, Shuah Khan wrote:
>> ...
>
> The clock on your computer might be running just a wee bit ahead.
>
> Either that, or we're getting patches from the future.
>
> David
>

David,

I know what happened. I was testing suspend to disk with pm_trace 
enabled and forgot to set the correct time after the running the test. 
Generated the patch without realizing the time is incorrect. Would like 
me to re-generate it.

-- Shuah

Shuah Khan, Linux Kernel Developer - Open Source Group Samsung Research 
America (Silicon Valley) shuah.kh@samsung.com | (970) 672-0658
