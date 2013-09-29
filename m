Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755322Ab3I2UlR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Sep 2013 16:41:17 -0400
Received: from mail-ie0-f181.google.com ([209.85.223.181]:41213 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755099Ab3I2UlF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Sep 2013 16:41:05 -0400
Message-ID: <5248905E.8000801@gmail.com>
Date: Sun, 29 Sep 2013 16:41:02 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>
CC: Linux-Kernel mailing list <linux-kernel@vger.kernel.org>,
        Linux Torvalds <torvalds@osdl.org>, Alan Cox <alan@redhat.com>
Subject: Re: [PATCH 1/1] x86_64: add config options to optimize for newer
 AMD processors
References: <52486938.4090009@gmail.com> <20130929180101.GB5490@pd.tnic>
In-Reply-To: <20130929180101.GB5490@pd.tnic>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2013 02:01 PM, Borislav Petkov wrote:
> On Sun, Sep 29, 2013 at 01:54:00PM -0400, Austin S Hemmelgarn
> wrote:
>> From: Austin S. Hemmelgarn <ahferroin7@gmail.com>
>> 
>> This patch adds Kconfig options to allow optimization for AMD
>> family 10h, AMD Bulldozer, and AMD Piledriver derived CPU's in
>> version 3.12-rc2.  These provide noticeable improvements over the
>> K8 config option, and allow the kernel to take full advantage of
>> AMD specific instruction set extensions, such as ABM, LZCNT, and
>> POPCNT.
> 
> A patch like that keeps popping up every couple of months. Please
> show us those noticeable improvements because the guy last time
> failed to do so.
> 
> And also, keep in mind that distro kernels are built with 
> CONFIG_GENERIC_CPU so CPU-specific kernels are used only by the
> small percentage of people who actually do build their own
> kernels.
> 
> Thanks.
> 
While I understand that you want decisive proof that it provides an
improvement, does it specifically matter if the option is unused by
most people and doesn't result in a negative performance hit when used?

I will, however, do some intensive profiling over the next week and
get back to you about exact improvements.  Just in the past few days
of using it, I have noticed much better response time in time
sensitive user-space code (mostly emulators and multimedia apps).
