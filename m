Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161028AbaDBWLJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Apr 2014 18:11:09 -0400
Received: from mail-qc0-f175.google.com ([209.85.216.175]:53313 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933388AbaDBWLD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Apr 2014 18:11:03 -0400
MIME-Version: 1.0
In-Reply-To: <1396475058.32040.10.camel@joe-AO722>
References: <CAHWCVW+cH6MwhQj-JGWN63AqseFYuDPoftv+zGJU8UDfAgueEQ@mail.gmail.com>
 <20140402123844.GE31892@arm.com> <20140402170747.GC24018@arm.com> <1396475058.32040.10.camel@joe-AO722>
From: Joe Sylve <joe.sylve@gmail.com>
Date: Wed, 2 Apr 2014 17:10:22 -0500
Message-ID: <CAHWCVWKng7rwewi6f0Tf1=uZRGERe56W6vRUuyCVtLz-gSz-9Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] AArch64: TCR_TG1_64K incorrectly sets TCR_EL1 bits [31:30]
To: Joe Perches <joe@perches.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Should it?  The reference manual refers to the architecture as AArch64.

On Wed, Apr 2, 2014 at 4:44 PM, Joe Perches <joe@perches.com> wrote:
> On Wed, 2014-04-02 at 18:07 +0100, Catalin Marinas wrote:
>> On Wed, Apr 02, 2014 at 01:38:44PM +0100, Catalin Marinas wrote:
>> > On Wed, Apr 02, 2014 at 05:00:38AM +0100, Joe Sylve wrote:
>> > > Section D7.2.83 TCR_EL1, Translation Control Register (EL1) of the
>> > > latest ARM Architecture Reference Manual, ARMv8, for ARMv8-A states
>> > > that TCR_EL1 TG1 (bits [31:30]) should be set to 11 for a 64KB
>> > > TTBR1_EL1 granule size. The mainline 3.14 kernel incorrectly sets
>> > > those bits to 01 (which is a 16KB granule size).
>
> trivia:
>
> I think the subject title should be arm64
>
>
