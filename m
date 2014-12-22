Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127AbaLVWLs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 17:11:48 -0500
Received: from mail-la0-f45.google.com ([209.85.215.45]:49397 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754702AbaLVWLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 17:11:47 -0500
MIME-Version: 1.0
In-Reply-To: <54985686.7080609@freebsd.org>
References: <1419087601-4889-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
 <1419269161.3786.4.camel@infradead.org> <54985686.7080609@freebsd.org>
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Date: Mon, 22 Dec 2014 23:11:24 +0100
Message-ID: <CAFo99gZsG5P6FGLqo02vyCueg4iuSpZqRU5a0BvzvtMhcRs0hw@mail.gmail.com>
Subject: Re: [PATCH] arch: powerpc: platforms: ps3: repository.c: Remove
 unused function
To: Nathan Whitehorn <nwhitehorn@freebsd.org>
Cc: Geoff Levand <geoff@infradead.org>, Andre Heider <a.heider@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>, linuxppc-dev@lists.ozlabs.org,
        cbe-oss-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2014-12-22 18:36 GMT+01:00 Nathan Whitehorn <nwhitehorn@freebsd.org>:
>
> On 12/22/14 09:26, Geoff Levand wrote:
>>
>> On Sat, 2014-12-20 at 16:00 +0100, Rickard Strandqvist wrote:
>>>
>>> Remove the function ps3_repository_write_highmem_info() that is not used
>>> anywhere.
>>
>> NAK
>>
>> ps3_repository_write_highmem_info() is needed by otheros++.  What we
>> need is a kernel patch to add the highmem info to the repository once it
>> is known.
>>
>> These ps3_repository_write_highmem routines are also the only
>> documentation the freeBSD port has as to how the highmem info is (should
>> be) saved in the repository.
>>
>> -Geoff
>>
>>
>
> Yes, we really need this for FreeBSD since that port uses the repository
> directly instead of FDT. Thanks for noticing this. We could adapt FreeBSD to
> use FDT (this is the only non-device-tree PowerPC port), but there hasn't
> been any reason to do that thus far given the availability of the repository
> information.
> -Nathan



Hi

Too bad that did not have the benefit of the patch, but it looks like
something good come because of it anyhow.

Kind regards
Rickard Strandqvist
