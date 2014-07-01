Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbaGAAGs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:06:48 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:44847 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaGAAGr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:06:47 -0400
MIME-Version: 1.0
X-Originating-IP: [2620:0:1000:157d:19a6:92bf:f0af:3806]
In-Reply-To: <alpine.DEB.2.02.1407010040410.29513@scotdoyle.com>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org>
	<CAOesGMiNhNavOMhBWcH_sEbNHxJ4OM3wjVt4qeK=aZFeVVxT_g@mail.gmail.com>
	<CANLzEksDfdb+RBtv8Kwe0KWpi23Nf7FS3-w+kXJXqV4n5XP=WQ@mail.gmail.com>
	<alpine.DEB.2.02.1407010040410.29513@scotdoyle.com>
Date: Mon, 30 Jun 2014 17:06:46 -0700
Message-ID: <CAOesGMieZtmyr2+eLnY7COgPCkU=sXABd35SckbZE+OMaCBO4g@mail.gmail.com>
Subject: Re: [PATCH 0/3] platform/chrome: chromeos_laptop - Add Haswell Chromebooks
From: Olof Johansson <olof@lixom.net>
To: Scot Doyle <lkml14@scotdoyle.com>
Cc: Benson Leung <bleung@chromium.org>, gene.chen@intel.com, moch@chromium.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, not yet. I'll do a pass of merges of this (and arm-soc) on Wednesday.


-Olof

On Mon, Jun 30, 2014 at 5:05 PM, Scot Doyle <lkml14@scotdoyle.com> wrote:
> Hi Olof, did you apply these patches? I haven't seen them in 3.16-rc3,
> linux-next, kernel/git/olof/chrome-platform, kernel/git/olof/misc, or
> kernel/git/arm/arm-soc.
>
> Thanks,
> Scot
>
>
> On Tue, 17 Jun 2014, Benson Leung wrote:
>>
>> Looks like -rc1 is here, so I'll respin these and send them out again.
>>
>> On Tue, Jun 3, 2014 at 3:59 PM, Olof Johansson <olof@lixom.net> wrote:
>>>
>>> Hi,
>>>
>>> On Tue, Jun 3, 2014 at 3:44 PM, Benson Leung <bleung@chromium.org> wrote:
>>>>
>>>> This patch series should be applied after Mika Westerberg's patch here:
>>>> https://patchwork.kernel.org/patch/4288591/
>>>>
>>>> It will add support for the cypress touchpads on the HP Chromebook 14,
>>>> Dell Chromebook 11, and Toshiba CB35.
>>>>
>>>> [PATCH 1/3] platform/chrome: chromeos_laptop - Add HP Chromebook 14
>>>> [PATCH 2/3] platform/chrome: chromeos_laptop - Add Dell Chromebook 11
>>>> Touch
>>>> [PATCH 3/3] platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch
>>>
>>>
>>> The 3.16 merge window is open, please resend after -rc1 and I'll queue it
>>> up.
>>>
>>>
>>> -Olof
