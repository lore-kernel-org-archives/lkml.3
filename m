Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755647AbaA1Wr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jan 2014 17:47:59 -0500
Received: from mail-ie0-f182.google.com ([209.85.223.182]:60527 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212AbaA1Wr6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jan 2014 17:47:58 -0500
MIME-Version: 1.0
In-Reply-To: <52E82A40.3040104@intel.com>
References: <1390946665-2967-1-git-send-email-yinghai@kernel.org>
	<52E82A40.3040104@intel.com>
Date: Tue, 28 Jan 2014 14:47:57 -0800
X-Google-Sender-Auth: qXtIq5FcqTXO66MbgXXtrZDrEms
Message-ID: <CAE9FiQVGuN0f5xo9fbfsurmO3E=45A3m0oS75HYPV7BSEwrvsg@mail.gmail.com>
Subject: Re: [PATCH] memblock: Add limit checking to memblock_virt_alloc
From: Yinghai Lu <yinghai@kernel.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@linaro.org>, Olof Johansson <olof@lixom.net>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 28, 2014 at 2:08 PM, Dave Hansen <dave.hansen@intel.com> wrote:
> On 01/28/2014 02:04 PM, Yinghai Lu wrote:
>> In original bootmem wrapper for memblock, we have limit checking.
>>
>> Add it to memblock_virt_alloc, to address arm and x86 booting crash.
>>
>> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
>
> Do you have a git tree or cumulative set of patches that you'd like us
> to all test?  I'm happy to boot it on my system, I just want to make
> sure I've got the same set that you're testing.

This one should only affect on arm and x86 the 32 bit kernel with more
then 4G RAM.

thanks

Yinghai
