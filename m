Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935253Ab3DHLtD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 07:49:03 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:35178 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935157Ab3DHLs7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 07:48:59 -0400
Message-ID: <5162AE9E.9030404@ti.com>
Date: Mon, 8 Apr 2013 17:18:46 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Prabhakar Lad <prabhakar.csengg@gmail.com>
CC: DLOS <davinci-linux-open-source@linux.davincidsp.com>,
        LAK <linux-arm-kernel@lists.infradead.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        LMML <linux-media@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/3] media: davinci: vpss: enable vpss clocks
References: <1364903044-13752-1-git-send-email-prabhakar.csengg@gmail.com> <1364903044-13752-2-git-send-email-prabhakar.csengg@gmail.com> <51629B3D.4080905@ti.com> <CA+V-a8swx0LB0eK0bZwcuFhVCW2UB8Bvm3ebwMQifo=-TB6ASA@mail.gmail.com>
In-Reply-To: <CA+V-a8swx0LB0eK0bZwcuFhVCW2UB8Bvm3ebwMQifo=-TB6ASA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 4/8/2013 5:08 PM, Prabhakar Lad wrote:
> Sekhar,
> 
> On Mon, Apr 8, 2013 at 3:56 PM, Sekhar Nori <nsekhar@ti.com> wrote:
>> On 4/2/2013 5:14 PM, Prabhakar lad wrote:
>>> From: Lad, Prabhakar <prabhakar.csengg@gmail.com>
>>>
>>> By default the VPSS clocks were enabled in capture driver
>>> for davinci family which creates duplicates for dm355/dm365/dm644x.
>>> This patch adds support to enable the VPSS clocks in VPSS driver,
>>> which avoids duplication of code and also adding clock aliases.
>>>
>>> This patch uses PM runtime API to enable/disable instead common clock
>>> framework. con_ids for master and slave clocks of vpss is added in pm_domain
>>
>> Common clock framework in not (yet) used on DaVinci, so this is misleading.
>>
> OK, I'll make it 'This patch uses PM runtime API to enable/disable
> clock, instead
> of Davinci specific clock framework. con_ids for master and slave

may be just call it "DaVinci clock framework"

Thanks,
Sekhar
