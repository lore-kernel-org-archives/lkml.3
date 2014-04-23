Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932199AbaDWR7x (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:59:53 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:60615 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754203AbaDWR7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:59:50 -0400
Message-ID: <5357FF8E.9010809@codesourcery.com>
Date: Thu, 24 Apr 2014 01:59:42 +0800
From: Chung-Lin Tang <cltang@codesourcery.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ley Foon Tan <lftan@altera.com>, Arnd Bergmann <arnd@arndb.de>
CC: "H. Peter Anvin" <hpa@zytor.com>, Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        <Catalin.Marinas@arm.com>, Andrew Pinski <apinski@cavium.com>
Subject: Re: [PATCH 00/28] nios2 Linux kernel port
References: <1397824031-4892-1-git-send-email-lftan@altera.com>	<5354AD36.5090809@zytor.com>	<CAFiDJ5861HE4AXtio-8uNJppWE2oaPt9_OKyGV=Myb_3vPrOVA@mail.gmail.com>	<16597012.pEkDc99HDN@wuerfel> <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>
In-Reply-To: <CAFiDJ5_dUpVTSeC36AfNKVN7BOa9GQ5vwSEWricm=8Sam9mR2A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Apr 2014 17:59:47.0736 (UTC) FILETIME=[D0B6B980:01CF5F1D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014/4/22 07:20 PM, Ley Foon Tan wrote:
> On Tue, Apr 22, 2014 at 6:56 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>> > On Tuesday 22 April 2014 18:37:11 Ley Foon Tan wrote:
>>> >> Hi Arnd and Peter Anvin,
>>> >>
>>> >> Other than 64-bit time_t, clock_t and suseconds_t, can you confirm
>>> >> that we don't need to have 64 bit off_t? See detail in link below.
>>> >> I can submit the patches for 64-bit time changes
>>> >> (include/asm-generic/posix_types.h and other archs) if everyone is
>>> >> agreed on this.
>> >
>> > Yes.
> Okay, will doing that.

I believe that arm64 ILP32 will also be affected. What is the status of
this configuration? Has the glibc/kernel ABI been finalized?

Thanks,
Chung-Lin

