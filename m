Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755287Ab3BRQWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 11:22:44 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33929 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752661Ab3BRQWm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:22:42 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <20130218155439.GA902@onny>
References: <20130218155439.GA902@onny>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [Bisected] 3.7-rc1 can't resume
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Mon, 18 Feb 2013 08:21:03 -0800
To: Jonas Heinrich <onny@project-insanity.org>, len.brown@intel.com,
        pavel@ucw.cz, tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        rjw@sisk.pl
CC: linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Message-ID: <cfd96a3d-5834-4687-b9de-9f044f43b588@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I might be able to get my hands on a T43 later this week and see if I can reproduce this.  This patch seems more plausible, at least... but still puzzling.

Jonas Heinrich <onny@project-insanity.org> wrote:

>On 02-17 21:40, Rafael J. Wysocki wrote:
>> Does the commit immediately preceding this one behave correctly?
>Strangely the preceding commit works well, so I bisected the kernel
>again, this time more carefully and I've got a different result!
>(see bisect_log attachement).
>It seems to be commit 73201dbec64aebf6b0dca855b523f437972dc7bb 
>(https://patchwork.kernel.org/patch/1511921/).
>Someone on LKML already reported an issue with this commit
>(https://lkml.org/lkml/2012/10/18/228) , but Peter
>Anvins patch got already applied in newer versions.
>Reverting this patch with the recent git clone seems to be difficult
>because it already has too much dependencies.
>
>Additionally I've included dmesg dumps of the last good and the bad
>kernel version.
>
>On 02-17 12:52, H. Peter Anvin wrote:
>> T43 is quite old... which might have exposed unique bugs.  How
>reliable is the failure?  Even one misidentified commit results in git
>bisect giving garbage.
>It affects really all versions after that commit and the failure
>happens
>every time I try to resume my notebook.
>
>Best regards,
>Jonas

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
