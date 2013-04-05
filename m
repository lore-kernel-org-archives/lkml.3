Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162335Ab3DESKJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Apr 2013 14:10:09 -0400
Received: from mail-ia0-f180.google.com ([209.85.210.180]:65460 "EHLO
	mail-ia0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162274Ab3DESKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Apr 2013 14:10:07 -0400
MIME-Version: 1.0
In-Reply-To: <9825274.7u1gJKhUg4@skinner.arch.suse.de>
References: <1365119186-23487-1-git-send-email-yinghai@kernel.org>
	<2084826.BkfVPXvXDZ@skinner.arch.suse.de>
	<CAE9FiQXE5T=8RJ0FdrMfiTwZ_NDBwjsOM0q_SePWsuQ3tXMz6Q@mail.gmail.com>
	<9825274.7u1gJKhUg4@skinner.arch.suse.de>
Date: Fri, 5 Apr 2013 11:10:06 -0700
X-Google-Sender-Auth: 2Q1RmrJYd-vkhJOjOk0FUUybjx8
Message-ID: <CAE9FiQWaqJOZtCjzqB38bVmEnQKiFN1Uc3z0hWvT6vnbtuA7cw@mail.gmail.com>
Subject: Re: [PATCH v3 00/22] x86, ACPI, numa: Parse numa info early
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
        Tang Chen <tangchen@cn.fujitsu.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 5, 2013 at 9:36 AM, Thomas Renninger <trenn@suse.de> wrote:
>
> From acpi overriding parts:
> Tested-by: Thomas Renninger <trenn@suse.de>

Thanks a lot for testing.

>
> I also went through the override related patches and from
> what I can judge (certainly not the early memory, flat 32 bit memory you call it?
> specific parts), they look fine.

Yes, we call it "32bit flat mode"

Thanks

Yinghai
