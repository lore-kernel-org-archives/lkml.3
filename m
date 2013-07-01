Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab3GAR34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 13:29:56 -0400
Received: from mail-ea0-f179.google.com ([209.85.215.179]:44694 "EHLO
	mail-ea0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3GAR3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 13:29:55 -0400
Message-ID: <51D1BC8E.6000204@gmail.com>
Date: Mon, 01 Jul 2013 19:29:50 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Jason Cooper <jason@lakedaemon.net>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] DMA: Fix Marvell Orion and mv_xor after MEMSET removal
References: <1372690589-2218-1-git-send-email-sebastian.hesselbarth@gmail.com> <51D19CD1.3030900@gmail.com> <20130701151720.GC19937@titan.lakedaemon.net> <6583540.4QCOENPlIG@amdc1032>
In-Reply-To: <6583540.4QCOENPlIG@amdc1032>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/01/13 19:24, Bartlomiej Zolnierkiewicz wrote:
> On Monday, July 01, 2013 11:17:20 AM Jason Cooper wrote:
>> On Mon, Jul 01, 2013 at 05:14:25PM +0200, Sebastian Hesselbarth wrote:
>>> On 07/01/13 17:04, Jason Cooper wrote:
>>>> On Mon, Jul 01, 2013 at 04:56:29PM +0200, Sebastian Hesselbarth wrote:
>>> Also, I will sent a follow-up patch to remove memset references from
>>> Marvell SoC dts/dtsi and the binding documentation soon.
>>>
>>> I guess, Bartolomiej should pick them up and resend his patch set, or
>>> leave Marvell alone and you pick them up.
>>
>> If Bartolomiej doesn't take it, please split your changes into two
>> patches, one for plat-orion, and one for drivers.
>
> Andrew has already applied incremental patch fixing build problems to his
> tree (though it is not yet in linux-next):
>
> 	http://www.ozlabs.org/~akpm/mmots/broken-out/drivers-dma-remove-unused-support-for-memset-operations-v3.patch
>
> The rest of changes from Sebastian are contained in another incremental
> patch which I've attached to this mail. They can be also folded into
> the first patch (which is what Andrew will probably do before sending them
> to Linus).

Ok, great! Then I will sent the DT clean-up patches to be taken through
Jason's tree with the other stuff I have for v3.11-rc1.

Sebastian
