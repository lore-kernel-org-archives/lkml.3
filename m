Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab3DTHkU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Apr 2013 03:40:20 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:54640 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754311Ab3DTHkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Apr 2013 03:40:18 -0400
Message-ID: <5172466B.9080105@suse.cz>
Date: Sat, 20 Apr 2013 09:40:27 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:19.0) Gecko/20130124 Thunderbird/19.0
MIME-Version: 1.0
To: Matt Fleming <matt@console-pimps.org>
CC: Matt Fleming <matt.fleming@intel.com>, joeyli <jlee@suse.com>,
        matthew.garrett@nebula.com, cbouatmailru@gmail.com, ccross@android.com,
        keescook@chromium.org, Tony Luck <tony.luck@intel.com>,
        linux-efi@vger.kernel.org,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: Cannot add new efi boot entry
References: <516B1ED3.9040900@suse.cz> <1366106168.23707.9.camel@linux-s257.site> <516D23B5.4070209@intel.com> <516EB1B6.7050506@suse.cz> <516EB6F2.6070806@console-pimps.org> <51703664.40003@suse.cz>
In-Reply-To: <51703664.40003@suse.cz>
X-Enigmail-Version: 1.6a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/18/2013 08:07 PM, Jiri Slaby wrote:
> On 04/17/2013 04:51 PM, Matt Fleming wrote:
>> On 17/04/13 15:29, Jiri Slaby wrote:
>>> On 04/16/2013 12:11 PM, Matt Fleming wrote:
>>>> On 16/04/13 10:56, joeyli wrote:
>>>>> I think I just got the same situation on my side with Acer machine. I am
>>>>> trying Matthew's new patchset hope can avoid this situation:
>>>>>
>>>>> https://lkml.org/lkml/2013/4/15/473
>>>>
>>>> Please do let us know whether the patches work for you.
>>>
>>> Hmm, where did efi_query_variable_store in 3/3 come from?
>>
>> It's in a patch on the 'urgent' branch at,
>>
>>     git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git
> 
> The 3 patches plus that one work for me.

Actually they don't :(:
open("/sys/firmware/efi/vars/new_var", O_WRONLY) = 3
write(3,
"B\0o\0o\0t\0000\0000\0001\0003\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
2084) = -1 ENOSPC (No space left on device)
close(3)                                = 0

thanks,
-- 
js
suse labs
