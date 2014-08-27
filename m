Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933241AbaH0Gdr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 02:33:47 -0400
Received: from mail-yh0-f44.google.com ([209.85.213.44]:42260 "EHLO
	mail-yh0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933114AbaH0Gdq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 02:33:46 -0400
MIME-Version: 1.0
In-Reply-To: <20140820061706.GC20366@samfundet.no>
References: <1408469363-15901-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20140820061706.GC20366@samfundet.no>
Date: Wed, 27 Aug 2014 09:33:45 +0300
Message-ID: <CAHp75VcGPTCvs7Sq2VM5G9DDtkJYK+L1arGPn2nb-=14D=KCvw@mail.gmail.com>
Subject: Re: [PATCH v1 00/12] dmaengine: dw: remove slave_id, add PCI support
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        dmaengine <dmaengine@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 20, 2014 at 9:17 AM, Hans-Christian Egtvedt
<egtvedt@samfundet.no> wrote:
> Around Tue 19 Aug 2014 20:29:11 +0300 or thereabout, Andy Shevchenko wrote:
>> The patchset is targeting two things:
>>  - removal of slave_id which is deprecated (suggested by Arnd Bergmann)
>>  - support BayTrail and Braswell SoCs in PCI case
>>
>> They are tight with each other, thus comes in one series.
>>
>> The patch set was BAT tested on Braswell and BayTrail machines.
>>
>> We would like to push this through slave-dma tree, so, Mark, Greg,
>> Hans-Christian, and Haavard, please, Ack them if you have no objections.
>
> I had a look through the patches touching Atmel and AVR32 related files,
> mostly things I originally wrote or maintain. They seem all good, feel free
> to push the changes through the slave-dma tree.

Thank you!

-- 
With Best Regards,
Andy Shevchenko
