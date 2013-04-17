Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966861Ab3DQO4w (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 10:56:52 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47835 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966809Ab3DQO4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 10:56:51 -0400
Message-ID: <516EB82D.8090500@nod.at>
Date: Wed, 17 Apr 2013 16:56:45 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130215 Thunderbird/17.0.3
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Jiri Kosina <jkosina@suse.cz>, matt.fleming@intel.com,
        cbouatmailru@gmail.com, ccross@android.com, keescook@chromium.org,
        tony.luck@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, matthew.garrett@nebula.com
Subject: Re: [PATCH] x86,efi: Implement efi_no_storage_paranoia parameter
References: <1366153253-28572-1-git-send-email-richard@nod.at> <alpine.LRH.2.00.1304170116060.8789@twin.jikos.cz> <516E500E.3020909@nod.at> <516EB7E8.1030105@console-pimps.org>
In-Reply-To: <516EB7E8.1030105@console-pimps.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 17.04.2013 16:55, schrieb Matt Fleming:
> On 17/04/13 08:32, Richard Weinberger wrote:
>> Am 17.04.2013 01:16, schrieb Jiri Kosina:
>>> On Wed, 17 Apr 2013, Richard Weinberger wrote:
>>>> +static bool efi_no_storage_paranoia;
>>>> +EXPORT_SYMBOL_GPL(efi_no_storage_paranoia);
>>>
>>> Is there any particular reason to export this symbol?
>>
>> I saw that the other parameters in that file are exported too
>> and other (efi) drivers may also be interested in that symbol.
>> So I thought it is a good idea to export it too.
>
> I've applied this patch but I did drop the EXPORT_SYMBOL_GPL() line. If
> people want access to this symbol at some future date we can address
> that later.

Okay. I'm fine with this!

Thanks,
//richard

