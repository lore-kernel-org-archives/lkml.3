Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752025AbaLOOFJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:05:09 -0500
Received: from lists.s-osg.org ([54.187.51.154]:40245 "EHLO lists.s-osg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751488AbaLOOFE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:05:04 -0500
Message-ID: <548EEA88.2060206@osg.samsung.com>
Date: Mon, 15 Dec 2014 07:04:56 -0700
From: Shuah Khan <shuahkh@osg.samsung.com>
Organization: Samsung Open Source Group
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Subject: Re: [GIT PULL] kselftest-3.19-rc1
References: <548750AD.6090201@osg.samsung.com> <CA+55aFx2DSXuikfd-RyEN3V+OaLSYhWub92=NJsNXGUhVnKKFQ@mail.gmail.com>
In-Reply-To: <CA+55aFx2DSXuikfd-RyEN3V+OaLSYhWub92=NJsNXGUhVnKKFQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/13/2014 02:32 PM, Linus Torvalds wrote:
> On Tue, Dec 9, 2014 at 11:42 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>>
>> Please pull the following kselftest updates for 3.19-rc1. Details
>> in the singed tag:
> 
> Gaah. Why do you do this to me?
> 
>> git@gitolite.kernel.org:/pub/scm/linux/kernel/git/shuah/linux-kselftest
>> fixes
> 
> That's the wrong format, but it's also the wrong branch name.
> 
> What it *should* have said is
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
> tags/kselftest-3.19-rc1
> 
> which is actually publicly accessible, and has the right tag name.
> 
> EXCEPT THAT'S WRONG TOO! The actual kselftest-3.19-rc1 tag doesn't
> point to the commits in fixes at all! It points to commit
> 0df1f2487d2f, which is my 3.18-rc3 commit.
> 
> Please fix your script/workflow. I'm not pulling this mess.
> 

Sorry. I thought I have the workflow right. Doesn't look like I do.
I will fix it and send you another.

-- Shuah

-- 
Shuah Khan
Sr. Linux Kernel Developer
Samsung Open Source Group
Samsung Research America (Silicon Valley)
shuahkh@osg.samsung.com | (970) 217-8978
