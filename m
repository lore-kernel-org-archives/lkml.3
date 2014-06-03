Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932462AbaFCHe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2014 03:34:58 -0400
Received: from mail-qg0-f53.google.com ([209.85.192.53]:32937 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932228AbaFCHe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2014 03:34:57 -0400
MIME-Version: 1.0
In-Reply-To: <20140602143720.GB19809@trinity.fluff.org>
References: <CAPDyKFpkKNx17ha=WWAp4-6w3k4pRYSHUhOWHv1G+1_wAEBceA@mail.gmail.com>
	<20140602143720.GB19809@trinity.fluff.org>
Date: Tue, 3 Jun 2014 09:34:56 +0200
Message-ID: <CAPDyKFqM7uLzimAagBMNJ0j-KERgmE8UbpeEFswG5Z8oUruw2A@mail.gmail.com>
Subject: Re: [GIT PULL] MMC for v.3.16
From: Ulf Hansson <ulf.hansson@linaro.org>
To: Ben Dooks <ben@trinity.fluff.org>
Cc: Linus <torvalds@linux-foundation.org>,
        linux-mmc <linux-mmc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Chris Ball <chris@printf.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 June 2014 16:37, Ben Dooks <ben@trinity.fluff.org> wrote:
> On Mon, Jun 02, 2014 at 02:03:27PM +0200, Ulf Hansson wrote:
>> Hi Linus,
>>
>> This is the first PR I send to you as I am co-maintaining the MMC
>> subsystem with Chris Ball. You will receive a separate PR for MMC from
>> him as well, as usual.
>>
>> These patches are mainly updates for the mmci driver and have been
>> tested in linux-next.
>>
>> Some ARM SoC related patches are also included and those have been
>> acked from the corresponding maintainers to go through my mmc tree.
>>
>> Some more details in the signed tag.
>>
>> Kind regards
>> Ulf Hansson
>
> Hi, is it too late to get the sh-mmcif driver cleanups in? I posted
> them some time ago but they do not seem to have been applied.

Hi Ben,

Sorry! I have missed them in the earlier PRs I have sent to Chris.

I suppose Chris still can take some trivial patches for 3.16, since he
haven't send his PR yet.

Kind regards
Uffe

>
>
> --
> Ben Dooks, ben@fluff.org, http://www.fluff.org/ben/
>
> Large Hadron Colada: A large Pina Colada that makes the universe disappear.
>
