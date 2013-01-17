Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab3AQPkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 10:40:20 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:35537 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289Ab3AQPkS convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:4:2>);
	Thu, 17 Jan 2013 10:40:18 -0500
Message-Id: <50F8297002000078000B6E64@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Thu, 17 Jan 2013 15:40:16 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Matt Fleming" <matt@console-pimps.org>
Cc: "Bjorn Helgaas" <bhelgaas@google.com>,
        "Matthew Garrett" <mjg59@srcf.ucam.org>,
        "linux-efi" <linux-efi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] fix setup_efi_pci()
References: <50F3D70402000078000B530E@nat28.tlf.novell.com>
 <1358425782.8203.413.camel@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <1358425782.8203.413.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.01.13 at 13:29, Matt Fleming <matt@console-pimps.org> wrote:
> On Mon, 2013-01-14 at 08:59 +0000, Jan Beulich wrote:
>> This fixes three issues:
>> - missing parentheses around a flag test
>> - wrong memory type used for allocation intended to persist post-boot
>> - four similar build warnings on 32-bit (casts between different size
>>   pointers and integers)
>> 
>> Signed-off-by: Jan Beulich <jbeulich@suse.com>
>> 
>> ---
>>  arch/x86/boot/compressed/eboot.c |   12 ++++++------
>>  1 file changed, 6 insertions(+), 6 deletions(-)
> 
> Jan, could you resubmit items 2 and 3 as separate patches please?

Sure, will do (probably only after rc4 though).

> Item 1 on your list has already been fixed in Linus' tree,

Yet I know I checked the tree right before sending...

Jan

> commit 886d751a2ea99a160f2d0a472231566d9cb0cf58
> Author: Sasha Levin <sasha.levin@oracle.com>
> Date:   Thu Dec 20 14:11:33 2012 -0500
> 
>     x86, efi: correct precedence of operators in setup_efi_pci
>     
>     With the current code, the condition in the if() doesn't make much sense 
> due
>     precedence of operators.
>     
>     Signed-off-by: Sasha Levin <sasha.levin@oracle.com>
>     Link: 
> http://lkml.kernel.org/r/1356030701-16284-25-git-send-email-sasha.levi 
>     Cc: Matt Fleming <matt.fleming@intel.com>
>     Cc: Matthew Garrett <mjg@redhat.com>
>     Cc: Bjorn Helgaas <bhelgaas@google.com>
>     Cc: Seth Forshee <seth.forshee@canonical.com>
>     Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> 
> -- 
> Matt Fleming, Intel Open Source Technology Center



