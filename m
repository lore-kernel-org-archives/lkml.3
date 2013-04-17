Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966834Ab3DQOzm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:55:42 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47421 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966474Ab3DQOzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:55:39 -0400
Message-ID: <516EB7E8.1030105@console-pimps.org>
Date: Wed, 17 Apr 2013 15:55:36 +0100
From: Matt Fleming <matt@console-pimps.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Jiri Kosina <jkosina@suse.cz>, matt.fleming@intel.com,
        cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
Subject: Re: [PATCH] x86,efi: Implement efi_no_storage_paranoia parameter
References: <1366153253-28572-1-git-send-email-richard@nod.at> <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz> <516E500E.3020909@nod.at>
In-Reply-To: <516E500E.3020909@nod.at>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/04/13 08:32, Richard Weinberger wrote:
> Am 17.04.2013 01:16, schrieb Jiri Kosina:
>> On Wed, 17 Apr 2013, Richard Weinberger wrote:
>>> +static bool efi_no_storage_paranoia;
>>> +EXPORT_SYMBOL_GPL(efi_no_storage_paranoia);
>>
>> Is there any particular reason to export this symbol?
> 
> I saw that the other parameters in that file are exported too
> and other (efi) drivers may also be interested in that symbol.
> So I thought it is a good idea to export it too.

I've applied this patch but I did drop the EXPORT_SYMBOL_GPL() line. If
people want access to this symbol at some future date we can address
that later.

Thanks!

-- 
Matt Fleming, Intel Open Source Technology Center
