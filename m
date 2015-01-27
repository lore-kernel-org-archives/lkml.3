Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757776AbbA0CH4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 21:07:56 -0500
Received: from mail-ob0-f169.google.com ([209.85.214.169]:33686 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753759AbbA0CHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 21:07:53 -0500
MIME-Version: 1.0
In-Reply-To: <20150126151942.2dd88d5221423e7379b43a06@linux-foundation.org>
References: <1422107321-9973-1-git-send-email-opensource.ganesh@gmail.com>
	<20150126151942.2dd88d5221423e7379b43a06@linux-foundation.org>
Date: Tue, 27 Jan 2015 10:07:53 +0800
Message-ID: <CADAEsF-QuUwdOFhjg9aCLZYPhmuNY-CdXQLgv1V1LXUkcJ8ugg@mail.gmail.com>
Subject: Re: [PATCH] mm/zsmalloc: add log for module load/unload
From: Ganesh Mahendran <opensource.ganesh@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
        Linux-MM <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Andrew

2015-01-27 7:19 GMT+08:00 Andrew Morton <akpm@linux-foundation.org>:
> On Sat, 24 Jan 2015 21:48:41 +0800 Ganesh Mahendran <opensource.ganesh@gmail.com> wrote:
>
>> Sometimes, we want to know whether a module is loaded or unloaded
>> from the log.
>
> Why?  What's special about zsmalloc?
>
> Please provide much better justification than this.

When I debug with the zsmalloc module built in kernel.
After system boots up, I did not see:
/sys/kernel/debug/zsmalloc dir.

Although the reason for this is that I made a mistake. I
forgot to add debugfs entry in /etc/fstab.
But I think it is suitable to add information for a module load/unload.
Then we can get this by:
dmesg | grep zsmalloc.

Thanks.
