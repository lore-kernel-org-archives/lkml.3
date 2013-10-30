Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab3J3MoS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Oct 2013 08:44:18 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:53426 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab3J3MoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Oct 2013 08:44:16 -0400
MIME-Version: 1.0
In-Reply-To: <20131030123850.GA8193@console-pimps.org>
References: <1381775837-26023-1-git-send-email-geyslan@gmail.com>
	<20131030123850.GA8193@console-pimps.org>
Date: Wed, 30 Oct 2013 10:44:16 -0200
Message-ID: <CAGG-pUQZ2R0JMZuGi07cL5q4EABYouZJfMpkO6YPy+ry2WkbNw@mail.gmail.com>
Subject: Re: [PATCH] efivarfs: 'efivarfs_file_write' function reorganization
From: =?ISO-8859-1?Q?Geyslan_Greg=F3rio_Bem?= <geyslan@gmail.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: matthew.garrett@nebula.com, Jeremy Kerr <jk@ozlabs.org>,
        matt.fleming@intel.com, linux-efi@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-br <kernel-br@googlegroups.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/10/30 Matt Fleming <matt@console-pimps.org>:
> On Mon, 14 Oct, at 03:37:17PM, Geyslan G. Bem wrote:
>> This reorganization:
>>
>> Adds 'attrsize' variable to make the code cleaner and more
>> understandable, replacing all 'sizeof(attributes)'.
>>
>> Removes 'bytes' prior assignment due this new approach.
>>
>> Uses 'memdup_user' instead 'kmalloc' + 'copy_from_user'.
>>
>> Signed-off-by: Geyslan G. Bem <geyslan@gmail.com>
>> ---
>>  fs/efivarfs/file.c | 23 +++++++++--------------
>>  1 file changed, 9 insertions(+), 14 deletions(-)
>
> Hmm.. I'm not convinced this is much of an improvement. I think removing
> 'sizeof(attributes)' actually makes the code harder to read.
>
> --
> Matt Fleming, Intel Open Source Technology Center

Do you want that I undo that? I aggre that the variable use only
reduces the line code.

-- 
Regards,

Geyslan G. Bem
hackingbits.com
