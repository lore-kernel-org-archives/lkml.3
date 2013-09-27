Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab3I0TVl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 15:21:41 -0400
Received: from mailout1.w2.samsung.com ([211.189.100.11]:13458 "EHLO
	usmailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754013Ab3I0TVh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 15:21:37 -0400
X-AuditID: cbfec37d-b7f0e6d00000657c-56-5245dac06f85
Message-id: <5245DABD.6090006@samsung.com>
Date: Fri, 27 Sep 2013 13:21:33 -0600
From: Shuah Khan <shuah.kh@samsung.com>
Reply-to: shuah.kh@samsung.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803
 Thunderbird/17.0.8
MIME-version: 1.0
To: Teck Choon Giam <giamteckchoon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [ 00/28] 3.0.97-stable review
References: <20130925000648.404447782@linuxfoundation.org>
 <52439A60.3080501@samsung.com> <20130926024517.GA24271@kroah.com>
 <CAEwRVpPoowYnTGJoeQ9Adh3Z_QjFbUYpKMARPARgwGjNVc1X2g@mail.gmail.com>
In-reply-to: <CAEwRVpPoowYnTGJoeQ9Adh3Z_QjFbUYpKMARPARgwGjNVc1X2g@mail.gmail.com>
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
X-Originating-IP: [105.144.21.63]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrNLMWRmVeSWpSXmKPExsVy+t9hP90Dt1yDDFZ9ELCYs34Nm8XX6TfY
	LZoXr2ezuLxrDpD708FiwcZHjBaP+t6yO7B77Jx1l93jxIzfLB77565h9/i8SS6AJYrLJiU1
	J7MstUjfLoErY82166wFP/grHu+bwtrAeJSni5GTQ0LARGLN0mZmCFtM4sK99WxdjFwcQgLL
	GCVmLz/MDuH0Mkl8ePqTFcLZyChxctlqFpAWXgEtie7b78HaWQRUJdYe6WUCsdkE1CU+v97B
	DmILCchJNC1ZDVYjKhAhsXLJA1aIXkGJH5Pvgc0REdCVWL9jHtg2ZoEJTBJX7z4AaxAGWvD4
	XxMLxOajjBLPHl4B6+AUCJZ4ufs62CRmAWuJlZO2MULY8hKb17xlhtisLPHn8imgiziAnlOU
	2L7aagKjyCwku2ch6Z6FpHsBI/MqRrHS4uSC4qT01AoTveLE3OLSvHS95PzcTYyQCKrdwXj/
	q80hRgEORiUe3hkHXIOEWBPLiitzDzFKcDArifAKLwAK8aYkVlalFuXHF5XmpBYfYmTi4JRq
	YJyQdG1didjz0PC1lquKLP0Pfbr5Mr+q53gJ96TD5x09Hv72+in2tiXvqdYt574pCx9zWgkd
	aMkXfOp8+IZo8J3eRzktE2YqVx8t/7q/5vGSSyleTs3qYi3njqa453Hve/fhaIhD0BcnC9cA
	X/mwp/ts/Orn7y3bOrFyQeNFqdCVa0OO9e5XeKHEUpyRaKjFXFScCAC498xjfgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/27/2013 12:52 PM, Teck Choon Giam wrote:
> On Thu, Sep 26, 2013 at 10:45 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
>> On Wed, Sep 25, 2013 at 08:22:24PM -0600, Shuah Khan wrote:
>>> On 09/24/2013 06:07 PM, Greg Kroah-Hartman wrote:
>>>> This is the start of the stable review cycle for the 3.0.97 release.
>>>> There are 28 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Fri Sep 27 00:05:34 UTC 2013.
>>>> Anything received after that time might be too late.
>>>>
>>>> The whole patch series can be found in one patch at:
>>>>      kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.97-rc1.gz
>>>> and the diffstat can be found below.
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>>
>>>
>>> 3.0.97-rc1 applied with the following warning from line 103 to 3.0.96
>>>
>>> patch-3.0.97-rc1:103: space before tab in indent.
>>>                           return -1;
>>> warning: 1 line adds whitespace errors.
>>
>> Any hint as to what file that was for?
>
> git am ../patches/v3.0.97/0019-HID-validate-HID-report-id-size.patch ...
> Applying: HID: validate HID report id size
> /home/choon/build/choon-GT-I9100-HK-JB-kernel-u2/.git/rebase-apply/patch:30:
> space before tab in indent.
>               return -1;
> warning: 1 line adds whitespace errors.
>
> So it is 0019-HID-validate-HID-report-id-size.patch
>
> I got it from doing the following:
>
> git format-patch -o ../patches/v3.0.97 v3.0.96..v3.0.97
>
> Thanks.
>
> Kindest regards,
> Giam Teck Choon
>

Thanks for the information. Yes that is the right patch.

diff --git a/drivers/hid/hid-core.c b/drivers/hid/hid-core.

+                       return -1;

There is a whitespace at the beginning.

-- Shuah

-- 
Shuah Khan
Senior Linux Kernel Developer - Open Source Group
Samsung Research America(Silicon Valley)
shuah.kh@samsung.com | (970) 672-0658
