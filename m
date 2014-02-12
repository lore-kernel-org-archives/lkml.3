Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754518AbaBLVc1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Feb 2014 16:32:27 -0500
Received: from mail-ve0-f180.google.com ([209.85.128.180]:46025 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470AbaBLVc0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Feb 2014 16:32:26 -0500
MIME-Version: 1.0
In-Reply-To: <52FBE5A5.3040602@converseincode.com>
References: <1392238726-18787-1-git-send-email-dl9pf@gmx.de>
	<20140212211159.GA29409@infradead.org>
	<52FBE5A5.3040602@converseincode.com>
Date: Wed, 12 Feb 2014 22:32:25 +0100
Message-ID: <CAFLxGvyYwnpv5pises2sE=sHf2nO5aayc7HPAcCmFP0F-Mpaug@mail.gmail.com>
Subject: Re: [PATCH] x86, acpi: LLVMLinux: Remove nested functions from
 Thinkpad ACPI
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Behan Webster <behanw@converseincode.com>
Cc: Christoph Hellwig <hch@infradead.org>, dl9pf@gmx.de,
        David Woodhouse <David.Woodhouse@intel.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 12, 2014 at 10:20 PM, Behan Webster
<behanw@converseincode.com> wrote:
> On 02/12/14 13:11, Christoph Hellwig wrote:
>>
>> On Wed, Feb 12, 2014 at 09:58:46PM +0100, dl9pf@gmx.de wrote:
>>>
>>> being able to compile the Linux kernel with Clang. The use of nested
>>> functions
>>> blocks this effort.
>>
>> Is there any good way to make gcc warn about the use of nested functions?
>
> Interesting idea.
>
> '-Wtrampolines'
>      Warn about trampolines generated for pointers to nested functions.
>
>      A trampoline is a small piece of data or code that is created at
>      run time on the stack when the address of a nested function is
>      taken, and is used to call the nested function indirectly.  For
>      some targets, it is made up of data only and thus requires no
>      special treatment.  But, for most targets, it is made up of code
>      and thus requires the stack to be made executable in order for the
>      program to work properly.
>
>
> That might work.

I gave it a quick try, but gcc (4.7) did not bark.

-- 
Thanks,
//richard
