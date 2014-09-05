Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932844AbaIEOYr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Sep 2014 10:24:47 -0400
Received: from mail-qg0-f48.google.com ([209.85.192.48]:42716 "EHLO
	mail-qg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473AbaIEOYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Sep 2014 10:24:45 -0400
MIME-Version: 1.0
In-Reply-To: <5409C19C.4030901@roeck-us.net>
References: <20140826230858.GA29970@kroah.com>
	<20140827045938.GA28282@roeck-us.net>
	<540813A5.7020704@huawei.com>
	<20140904183953.GA28599@roeck-us.net>
	<54096C8D.8000008@huawei.com>
	<5409C19C.4030901@roeck-us.net>
Date: Fri, 5 Sep 2014 08:24:44 -0600
Message-ID: <CAKocOOOFkeV7-XExOtE1itchbO6hPrOXPgNtGa-BtdFU=aaSWA@mail.gmail.com>
Subject: Re: [kernel.org PATCH] Li Zefan is now the 3.4 stable maintainer
From: Shuah Khan <shuahkhan@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Li Zefan <lizefan@huawei.com>, stable <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 5, 2014 at 7:58 AM, Guenter Roeck <linux@roeck-us.net> wrote:

>>
>> Yeah, I've fixed it. I'll run dos2unix for every patch file.
>>
>
> Yes, it now works. Wonder how it comes that the patch in Greg's patch tree
> didn't have the problem. Any idea ?
>

I am interested in the answer to your question. I used git am and then
ran checkpatch
on the patched file to make sure, there are no warnings. I didn't see
any warnings on
the files I patched with git am. Hope that means it is good.

Maybe I should start using dos2unix to be safe.

-- Shuah
