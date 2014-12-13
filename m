Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354AbaLMVci (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2014 16:32:38 -0500
Received: from mail-qc0-f172.google.com ([209.85.216.172]:43403 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932280AbaLMVcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2014 16:32:36 -0500
MIME-Version: 1.0
In-Reply-To: <548750AD.6090201@osg.samsung.com>
References: <548750AD.6090201@osg.samsung.com>
Date: Sat, 13 Dec 2014 13:32:35 -0800
X-Google-Sender-Auth: F60TXigctrtfWJcN3a9iIiNhN5E
Message-ID: <CA+55aFx2DSXuikfd-RyEN3V+OaLSYhWub92=NJsNXGUhVnKKFQ@mail.gmail.com>
Subject: Re: [GIT PULL] kselftest-3.19-rc1
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Shuah Khan <shuahkh@osg.samsung.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Shuah Khan <shuah.kh@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 9, 2014 at 11:42 AM, Shuah Khan <shuahkh@osg.samsung.com> wrote:
>
> Please pull the following kselftest updates for 3.19-rc1. Details
> in the singed tag:

Gaah. Why do you do this to me?

> git@gitolite.kernel.org:/pub/scm/linux/kernel/git/shuah/linux-kselftest
> fixes

That's the wrong format, but it's also the wrong branch name.

What it *should* have said is

  git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest
tags/kselftest-3.19-rc1

which is actually publicly accessible, and has the right tag name.

EXCEPT THAT'S WRONG TOO! The actual kselftest-3.19-rc1 tag doesn't
point to the commits in fixes at all! It points to commit
0df1f2487d2f, which is my 3.18-rc3 commit.

Please fix your script/workflow. I'm not pulling this mess.

                      Linus
