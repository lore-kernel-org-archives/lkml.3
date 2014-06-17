Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933206AbaFQOpc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jun 2014 10:45:32 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:63412 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973AbaFQOpa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jun 2014 10:45:30 -0400
MIME-Version: 1.0
In-Reply-To: <CAOesGMiNhNavOMhBWcH_sEbNHxJ4OM3wjVt4qeK=aZFeVVxT_g@mail.gmail.com>
References: <1401835464-15267-1-git-send-email-bleung@chromium.org>
	<CAOesGMiNhNavOMhBWcH_sEbNHxJ4OM3wjVt4qeK=aZFeVVxT_g@mail.gmail.com>
Date: Tue, 17 Jun 2014 07:45:29 -0700
X-Google-Sender-Auth: JIp_Z6MN5BvXyyrSM71W6h4jrnA
Message-ID: <CANLzEksDfdb+RBtv8Kwe0KWpi23Nf7FS3-w+kXJXqV4n5XP=WQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] platform/chrome: chromeos_laptop - Add Haswell Chromebooks
From: Benson Leung <bleung@chromium.org>
To: Olof Johansson <olof@lixom.net>
Cc: gene.chen@intel.com, moch@chromium.org,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like -rc1 is here, so I'll respin these and send them out again.

On Tue, Jun 3, 2014 at 3:59 PM, Olof Johansson <olof@lixom.net> wrote:
> Hi,
>
> On Tue, Jun 3, 2014 at 3:44 PM, Benson Leung <bleung@chromium.org> wrote:
>> This patch series should be applied after Mika Westerberg's patch here:
>> https://patchwork.kernel.org/patch/4288591/
>>
>> It will add support for the cypress touchpads on the HP Chromebook 14,
>> Dell Chromebook 11, and Toshiba CB35.
>>
>> [PATCH 1/3] platform/chrome: chromeos_laptop - Add HP Chromebook 14
>> [PATCH 2/3] platform/chrome: chromeos_laptop - Add Dell Chromebook 11 Touch
>> [PATCH 3/3] platform/chrome: chromeos_laptop - Add Toshiba CB35 Touch
>
> The 3.16 merge window is open, please resend after -rc1 and I'll queue it up.
>
>
> -Olof



-- 
Benson Leung
Software Engineer, Chrom* OS
bleung@chromium.org
