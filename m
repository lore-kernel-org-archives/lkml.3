Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753383AbaGAAFh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jun 2014 20:05:37 -0400
Received: from mx1.scotdoyle.com ([69.85.92.149]:48341 "EHLO mx1.scotdoyle.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815AbaGAAFg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jun 2014 20:05:36 -0400
Date: Tue, 1 Jul 2014 01:05:26 +0100 (BST)
From: Scot Doyle <lkml14@scotdoyle.com>
To: Olof Johansson <olof@lixom.net>
cc: Benson Leung <bleung@chromium.org>, gene.chen@intel.com, moch@chromium.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] platform/chrome: chromeos_laptop - Add Haswell
 Chromebooks
In-Reply-To: <CANLzEksDfdb+RBtv8Kwe0KWpi23Nf7FS3-w+kXJXqV4n5XP=WQ@mail.gmail.com>
Message-ID: <alpine.DEB.2.02.1407010040410.29513@scotdoyle.com>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org> <CAOesGMiNhNavOMhBWcH_sEbNHxJ4OM3wjVt4qeK=aZFeVVxT_g@mail.gmail.com> <CANLzEksDfdb+RBtv8Kwe0KWpi23Nf7FS3-w+kXJXqV4n5XP=WQ@mail.gmail.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Olof, did you apply these patches? I haven't seen them in 3.16-rc3, 
linux-next, kernel/git/olof/chrome-platform, kernel/git/olof/misc, or 
kernel/git/arm/arm-soc.

Thanks,
Scot

On Tue, 17 Jun 2014, Benson Leung wrote:
> Looks like -rc1 is here, so I'll respin these and send them out again.
>
> On Tue, Jun 3, 2014 at 3:59 PM, Olof Johansson <olof@lixom.net> wrote:
>> Hi,
>>
>> On Tue, Jun 3, 2014 at 3:44 PM, Benson Leung <bleung@chromium.org> wrote:
>>> This patch series should be applied after Mika Westerberg's patch here:
>>> https://patchwork.kernel.org/patch/4288591/
>>>
>>> It will add support for the cypress touchpads on the HP Chromebook 14,
>>> Dell Chromebook 11, and Toshiba CB35.
>>>
>>> [PATCH 1/3] platform/chrome: chromeos_laptop - Add HP Chromebook 14
>>> [PATCH 2/3] platform/chrome: chromeos_laptop - Add Dell Chromebook 11 Touch
>>> [PATCH 3/3] platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch
>>
>> The 3.16 merge window is open, please resend after -rc1 and I'll queue it up.
>>
>>
>> -Olof
