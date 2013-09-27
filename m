Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754599Ab3I0Swt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Sep 2013 14:52:49 -0400
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35382 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338Ab3I0Swr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Sep 2013 14:52:47 -0400
MIME-Version: 1.0
In-Reply-To: <20130926024517.GA24271@kroah.com>
References: <20130925000648.404447782@linuxfoundation.org>
	<52439A60.3080501@samsung.com>
	<20130926024517.GA24271@kroah.com>
Date: Sat, 28 Sep 2013 02:52:45 +0800
Message-ID: <CAEwRVpPoowYnTGJoeQ9Adh3Z_QjFbUYpKMARPARgwGjNVc1X2g@mail.gmail.com>
Subject: Re: [ 00/28] 3.0.97-stable review
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Shuah Khan <shuah.kh@samsung.com>, LKML <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>, stable@vger.kernel.org,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 10:45 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Sep 25, 2013 at 08:22:24PM -0600, Shuah Khan wrote:
>> On 09/24/2013 06:07 PM, Greg Kroah-Hartman wrote:
>> > This is the start of the stable review cycle for the 3.0.97 release.
>> > There are 28 patches in this series, all will be posted as a response
>> > to this one.  If anyone has any issues with these being applied, please
>> > let me know.
>> >
>> > Responses should be made by Fri Sep 27 00:05:34 UTC 2013.
>> > Anything received after that time might be too late.
>> >
>> > The whole patch series can be found in one patch at:
>> >     kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.0.97-rc1.gz
>> > and the diffstat can be found below.
>> >
>> > thanks,
>> >
>> > greg k-h
>> >
>>
>> 3.0.97-rc1 applied with the following warning from line 103 to 3.0.96
>>
>> patch-3.0.97-rc1:103: space before tab in indent.
>>                          return -1;
>> warning: 1 line adds whitespace errors.
>
> Any hint as to what file that was for?

git am ../patches/v3.0.97/0019-HID-validate-HID-report-id-size.patch ...
Applying: HID: validate HID report id size
/home/choon/build/choon-GT-I9100-HK-JB-kernel-u2/.git/rebase-apply/patch:30:
space before tab in indent.
             return -1;
warning: 1 line adds whitespace errors.

So it is 0019-HID-validate-HID-report-id-size.patch

I got it from doing the following:

git format-patch -o ../patches/v3.0.97 v3.0.96..v3.0.97

Thanks.

Kindest regards,
Giam Teck Choon


>
>> Compiled and booted on the following systems:
>>
>> HP ProBook 6475b AMD A10-4600M APU with Radeon(tm) HD Graphics
>>
>> dmesgs look good. No regressions compared to the previous dmesgs for
>> this release. dmesg emerg, crit, alert, err are clean. No regressions in
>> warn.
>
> Great, thanks for testing and letting me know.
>
> greg k-h
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
