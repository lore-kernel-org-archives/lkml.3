Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753674AbaKMClV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 21:41:21 -0500
Received: from mail-pa0-f53.google.com ([209.85.220.53]:36017 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753387AbaKMClU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 21:41:20 -0500
Message-ID: <54641BC1.3050008@gmail.com>
Date: Thu, 13 Nov 2014 10:47:29 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.9; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@ezchip.com>
CC: rdunlap@infradead.org, rickard_strandqvist@spectrumdigital.se,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch: tile: gxio: Export symbols for module using in
 'mpipe.c'
References: <cr8vqhwy7vrnhtnbt7587wmv.1415751123895@email.android.com> <5463C07E.7070505@ezchip.com>
In-Reply-To: <5463C07E.7070505@ezchip.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/14 4:18, Chris Metcalf wrote:
> On 11/11/2014 7:16 PM, Chen Gang wrote:
>> And I also want to consult, can tile be run under qemu or other
>> simulators? Welcome any ideas, suggestions, and completions.
> 
> Our use of qemu so far as been purely in the context of virtualization,
> where it functions as the KVM driver.  No one has looked into using qemu
> as an instruction simulator, for example.  Patches welcome :-)
> 

OK, thank you for your information. And excuse me, at present, I have 
no enough time resources (maybe neither have ability) for constructing
tile qemu instruction simulator.

> We do have a simulator, but for the time being, it's only available
> as part of chip sales to our customers.
> 

OK, thanks. Next, I shall consult toolchains tile members for it to try
to find another ways for virtual environments (e.g. binutils/sim,
although I can not find tile under binutils/sim).

If I really can not find any virtual environments for tile, I have to
only try to test tile toolchains (gcc/binutils/libc) under full
cross-building environments, and skip tests under virtual environments.


Thanks.
-- 
Chen Gang

Open, share, and attitude like air, water, and life which God blessed
