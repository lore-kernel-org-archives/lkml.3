Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754138Ab3DKNKK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 09:10:10 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:56874 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262Ab3DKNKI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 09:10:08 -0400
Message-ID: <5166B62F.4000206@console-pimps.org>
Date: Thu, 11 Apr 2013 14:10:07 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Tom Gundersen <teg@jklm.no>
Subject: Re: [PATCH 2/6] efivars: Keep a private global pointer to efivars
References: <1365077935-6859-1-git-send-email-matt@console-pimps.org> <1365077935-6859-3-git-send-email-matt@console-pimps.org> <CAGTjWtAhLQVrpJSUWU=HgxuBkcjfPj_o4hN9o-ELK1g89eGA_Q@mail.gmail.com>
In-Reply-To: <CAGTjWtAhLQVrpJSUWU=HgxuBkcjfPj_o4hN9o-ELK1g89eGA_Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/13 23:07, Mike Waychison wrote:
>> +config EFI_VARS_GENERIC_OPS
>> +       bool
>> +       depends on EFI
>> +       depends on !GOOGLE_SMI
>> +       default y
>> +
> 
> So while we have no need to support both the gsmi and real efi
> entrypoints on any given machine, we still need to be able to support
> the operation of both from the same kernel build.  How do you feel
> about removing this bit and leaving it such that efivars_init
> continues to register the "generic" efivars regardless of
> CONFIG_GOOGLE_SMI?  The rest of the patch seems fine to me.

OK sure, we can do that. Thanks for the review.

-- 
Matt Fleming, Intel Open Source Technology Center
