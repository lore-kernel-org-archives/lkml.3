Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752119Ab3FZNqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 09:46:45 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42352 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab3FZNqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 09:46:43 -0400
MIME-Version: 1.0
In-Reply-To: <20130625182021.GA29955@srcf.ucam.org>
References: <1372183863-11333-1-git-send-email-leif.lindholm@linaro.org>
 <1372183863-11333-4-git-send-email-leif.lindholm@linaro.org> <20130625182021.GA29955@srcf.ucam.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 26 Jun 2013 14:46:22 +0100
X-Google-Sender-Auth: 3AXM1jbqbdlqy5oqjr9R9tsHszk
Message-ID: <CACxGe6tjZT4TjWhYt+eA8RAwBrgJqW+Dto8t3rFgs8C_PbE9rQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] arm: Add [U]EFI runtime services support
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Leif Lindholm <leif.lindholm@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-efi@vger.kernel.org,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 25, 2013 at 7:20 PM, Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> On Tue, Jun 25, 2013 at 07:11:02PM +0100, Leif Lindholm wrote:
>> This patch implements basic support for UEFI runtime services in the
>> ARM architecture - a requirement for using efibootmgr to read and update
>> the system boot configuration.
>>
>> It also locates any presented SMBIOS configuration table and stores it
>> for potential later use by DMI.
>
> This appears to duplicate code that's already duplicated between x86 and
> ia64. We made a mistake there originally - let's not do it again. Having
> this code in three places is inevitably going to lead to skew and missed
> bugfixes.

+1

>
> --
> Matthew Garrett | mjg59@srcf.ucam.org
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
