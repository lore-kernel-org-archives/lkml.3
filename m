Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756067Ab3JXTZA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 15:25:00 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:36087 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754997Ab3JXTY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 15:24:58 -0400
MIME-Version: 1.0
In-Reply-To: <20131024191821.GE2322@redhat.com>
References: <1381751200-27376-1-git-send-email-chaowang@redhat.com>
	<CAE9FiQUNMDuVZtqud3LBbAmE0SL8ZWLFnc+CSYZm4UfTvNUaOA@mail.gmail.com>
	<20131015144810.GI31215@redhat.com>
	<CAE9FiQXVCx__SuhAdO9_CNaRncW2HB2tv3UjZrQcbsTV35QWow@mail.gmail.com>
	<20131018123837.GB2277@redhat.com>
	<CAE9FiQWdMmSseDk6J=TOXT9ZahJUBf2BOU+VHJRXeeMofgH=EQ@mail.gmail.com>
	<20131021151643.GA20669@redhat.com>
	<CAE9FiQVfeUdugFRMt1DGjtqW2FAb2gfnGjXENHjoJ=JVAYbYgw@mail.gmail.com>
	<20131024140241.GA2322@redhat.com>
	<CAE9FiQUu0WwMgNpog4TKch+MT2i7_DsNvqZxbyQusS4AFxdhQQ@mail.gmail.com>
	<20131024191821.GE2322@redhat.com>
Date: Thu, 24 Oct 2013 12:24:57 -0700
X-Google-Sender-Auth: IZQaqpEkLpwflFSy1O_QHqmajqY
Message-ID: <CAE9FiQU7+FRY=3ETdGZJJfcS0vjRht4ZT8MHTQ66kpjD2MmrcA@mail.gmail.com>
Subject: Re: [PATCH] x86, kdump: crashkernel=X try to reserve below 896M
 first, then try below 4G, then MAXMEM
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Chao <chaowang@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Pekka Enberg <penberg@kernel.org>, Jacob Shin <jacob.shin@amd.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 24, 2013 at 12:18 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 24, 2013 at 12:15:25PM -0700, Yinghai Lu wrote:
>
> Also keeping things simple by not trying to *impose* a new crashkernel=
> syntax on existing crashkernel=xM users.

Existing user that have crashkernel=xM working with their old kernel
and old kexec-tools, they still could keep their old command line and
old kexec-tools
with new updated kernel.
We should not change semantics to surprise them.

Thanks

Yinghai
