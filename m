Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746AbaBLDQf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 22:16:35 -0500
Received: from mail-ob0-f178.google.com ([209.85.214.178]:40903 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbaBLDQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 22:16:33 -0500
MIME-Version: 1.0
In-Reply-To: <20140211202211.GA2306@kroah.com>
References: <1391828381-4303-1-git-send-email-sj38.park@gmail.com>
 <1391828381-4303-2-git-send-email-sj38.park@gmail.com> <20140211202211.GA2306@kroah.com>
From: SeongJae Park <sj38.park@gmail.com>
Date: Wed, 12 Feb 2014 12:16:01 +0900
Message-ID: <CAEjAshogowtLswHsciRVDyGiG5i+E=z-bycexUynBwYreCraqw@mail.gmail.com>
Subject: Re: [PATCH 2/2] staging: android: remove unused constant, BINDER_SET_IDLE_PRIORITY
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Brian Swetland <swetland@google.com>,
        arve@android.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 5:22 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Sat, Feb 08, 2014 at 11:59:41AM +0900, SeongJae Park wrote:
>> Remove constant BINDER_SET_IDLE_PRIORITY because it is not used from
>> anywhere.
>
>>
>> Signed-off-by: SeongJae Park <sj38.park@gmail.com>
>> ---
>>  drivers/staging/android/binder.h | 7 +++----
>>  1 file changed, 3 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/staging/android/binder.h b/drivers/staging/android/binder.h
>> index c4c1ed6..6d08e61 100644
>> --- a/drivers/staging/android/binder.h
>> +++ b/drivers/staging/android/binder.h
>> @@ -87,10 +87,9 @@ struct binder_version {
>>  #define BINDER_WRITE_READ            _IOWR('b', 1, struct binder_write_read)
>>  #define BINDER_SET_IDLE_TIMEOUT              _IOW('b', 3, __s64)
>>  #define BINDER_SET_MAX_THREADS               _IOW('b', 5, __u32)
>> -#define BINDER_SET_IDLE_PRIORITY     _IOW('b', 6, __s32)
>> -#define BINDER_SET_CONTEXT_MGR               _IOW('b', 7, __s32)
>> -#define BINDER_THREAD_EXIT           _IOW('b', 8, __s32)
>> -#define BINDER_VERSION                       _IOWR('b', 9, struct binder_version)
>> +#define BINDER_SET_CONTEXT_MGR               _IOW('b', 6, __s32)
>> +#define BINDER_THREAD_EXIT           _IOW('b', 7, __s32)
>> +#define BINDER_VERSION                       _IOWR('b', 8, struct binder_version)
>
> And you just broke all userspace code that uses this interface :(
>
> Please be more careful, and test your patches properly.

Definitely my fault... Sorry.
I will be more careful and will not do such mistake again.

>
> greg k-h
