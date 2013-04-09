Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935533Ab3DILSx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 07:18:53 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:53915 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935471Ab3DILSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 07:18:50 -0400
Message-ID: <5163F909.4030109@ti.com>
Date: Tue, 9 Apr 2013 16:48:33 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Prabhakar lad <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] ARM: davinci: dm355: add support for vpbe display
References: <1365413215-3632-1-git-send-email-prabhakar.csengg@gmail.com> <51629DA8.3040806@ti.com> <20130408075606.5a59d32c@redhat.com> <5162AE56.5090203@ti.com> <20130408095652.33dcb0be@redhat.com>
In-Reply-To: <20130408095652.33dcb0be@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 4/8/2013 6:26 PM, Mauro Carvalho Chehab wrote:
> Em Mon, 8 Apr 2013 17:17:34 +0530
> Sekhar Nori <nsekhar@ti.com> escreveu:
> 
>> Hi Maruo,
>>
>> On 4/8/2013 4:26 PM, Mauro Carvalho Chehab wrote:
>>> Hi Sekhar,
>>>
>>> Em Mon, 8 Apr 2013 16:06:24 +0530
>>> Sekhar Nori <nsekhar@ti.com> escreveu:
>>>
>>>> On 4/8/2013 2:56 PM, Prabhakar lad wrote:
>>>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>>>
>>>>> This patch series enables VPBE display driver on DM355.
>>>>
>>>> These (this and the DM365 one) patches look good to me. I need to get an
>>>> immutable branch from Mauro where dependencies are queued and then I can
>>>> generate a pull request for these for ARM SoC.
>>>
>>> Are you mean a branch at the media development tree for you to sent
>>> pull requests for me? If so, just use the "master" branch at the media
>>
>> The pull request will be sent to my upstreams (ie the ARM SoC folks -
>> Arnd and Olof). Since the platform data patches need driver patches to
>> be applied first, I need a non-rebasing branch containing the driver
>> stuff which I can use a dependency and apply platform patches on top.
> 
> Hmm... I generally wait for arch patches to be applied first, before
> sending driver patches. If you're willing to do that, I suggest that
> Arnd/Olof should put those patches on a separate topic branch, and
> sending an upstream pull request for them after mine.

The patches can be put on a separate branch, but the branch wont build
without the driver changes (eg need defintion of VPBE_ENC_DV_TIMINGS
from include/media/davinci/vpbe_types.h).

So this will need a immutable branch from you to depend on so Linus's
tree won't have duplicate commits when Arnd/Olof send their pull request.

> 
> If the patches are trivial, maybe the better would be to put both
> media and arm patches at the same tree, with the other maintainers'
> ack.

This seems to be the easiest path at the moment. I will ack the platform
parts and Prabhakar can issue a pull request for you. I have just
checked that these patches won't cause a merge conflict with anything
already queued through my tree.

Thanks,
Sekhar
