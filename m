Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752039AbaHaWpV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 18:45:21 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:62709 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbaHaWpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 18:45:16 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <5403A273.4070504@linux.intel.com>
References: <99jhsb6abtsilpt3j5nu991b.1409513632114@email.android.com> <5403A273.4070504@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [RFC v1 0/3] driver-core: add asynch module loading support
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date: Sun, 31 Aug 2014 15:45:11 -0700
To: Arjan van de Ven <arjan@linux.intel.com>,
        =?UTF-8?B?5ZC056ug6YeR?= <falcon@meizu.com>,
        Greg KH <gregkh@linuxfoundation.org>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        "tiwai@suse.de" <tiwai@suse.de>, "tj@kernel.org" <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oleg@redhat.com" <oleg@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "penguin-kernel@i-love.sakura.ne.jp" 
	<penguin-kernel@i-love.sakura.ne.jp>,
        "joseph.salisbury@canonical.com" <joseph.salisbury@canonical.com>,
        "bpoirier@suse.de" <bpoirier@suse.de>,
        "Luis R. Rodriguez" <mcgrof@suse.com>
Message-ID: <e781dc3b-5829-4bce-8a34-7ed708309f3b@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On August 31, 2014 3:32:19 PM PDT, Arjan van de Ven <arjan@linux.intel.com> wrote:
>On 8/31/2014 1:06 PM, 吴章金 wrote:
>> Hi, folks
>>
>> I'm back to this discussion,
>>
>> The original requirement of my first RFC patchset is mainly for
>Android Smartphone use case:
>>
>> 1. We want light on LCD and draw a logo immediately after power key
>press(don't consider uboot or lk biotloader here).
>> 2. We want the whole kernel boot fast to give user the Android Launch
>deaktop
>> 3. The modem initialization/reset is slow
>> 4. The Touchpad firmware upgrade is slow
>> 5. We have many cpu cores(up to 8 in latest exynos 5430 and
>MT6595...)
>> 6. We have few schedulable/parallellizable threads
>> 7. We compiled all of the modules in the kernel(stupid? avoid
>modprobe...but lose parallelization in userspace)
>>
>> So, I think about is that possible to async most of the probes, but
>still reserve the requred dependencies to let them still work as
>expected.
>
>you can boot a whole kernel including all graphics in less than 0.5
>seconds, even without this patchset.


You forgot to add "on certain subset of hardware and configuration".

Thanks.

-- 
Dmitry
