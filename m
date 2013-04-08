Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935192Ab3DHLry (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:47:54 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:49190 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935165Ab3DHLrx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:47:53 -0400
Message-ID: <5162AE56.5090203@ti.com>
Date: Mon, 8 Apr 2013 17:17:34 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Prabhakar lad <prabhakar.csengg@gmail.com>,
        DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v8 0/2] ARM: davinci: dm355: add support for vpbe display
References: <1365413215-3632-1-git-send-email-prabhakar.csengg@gmail.com> <51629DA8.3040806@ti.com> <20130408075606.5a59d32c@redhat.com>
In-Reply-To: <20130408075606.5a59d32c@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Maruo,

On 4/8/2013 4:26 PM, Mauro Carvalho Chehab wrote:
> Hi Sekhar,
> 
> Em Mon, 8 Apr 2013 16:06:24 +0530
> Sekhar Nori <nsekhar@ti.com> escreveu:
> 
>> On 4/8/2013 2:56 PM, Prabhakar lad wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> This patch series enables VPBE display driver on DM355.
>>
>> These (this and the DM365 one) patches look good to me. I need to get an
>> immutable branch from Mauro where dependencies are queued and then I can
>> generate a pull request for these for ARM SoC.
> 
> Are you mean a branch at the media development tree for you to sent
> pull requests for me? If so, just use the "master" branch at the media

The pull request will be sent to my upstreams (ie the ARM SoC folks -
Arnd and Olof). Since the platform data patches need driver patches to
be applied first, I need a non-rebasing branch containing the driver
stuff which I can use a dependency and apply platform patches on top.

> tree:
> 	http://git.linuxtv.org/media_tree.git
> 
> The master branch there is never rebased. I'll likely start to have
> topic branches on the next Kernel cycle, also at the same tree.

Ideally I will use the immutable branch which you will also use to send
pull request to Linus so there are not unnecessary merge conflicts. When
will those branches be ready?

Thanks,
Sekhar
