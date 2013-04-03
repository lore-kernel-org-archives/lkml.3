Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762799Ab3DCRcZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 13:32:25 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:42691 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758784Ab3DCRcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 13:32:24 -0400
MIME-Version: 1.0
In-Reply-To: <CAE9FiQUO-fLY-k_gmw6cg56YEN52VRvZuXr+f1EnywKr_cGc4Q@mail.gmail.com>
References: <1364923183-316-1-git-send-email-yinghai@kernel.org>
	<1364923183-316-4-git-send-email-yinghai@kernel.org>
	<20130402180606.GI29506@redhat.com>
	<CAE9FiQUKqv_t-99JN_t=EGop2-Wbjd4Yb9vYvU_SbbNctG6Yeg@mail.gmail.com>
	<CAE9FiQXEa0-WS8+E6LGy8CenoHX5qF1MpjBgejQx9-EvG_1rGw@mail.gmail.com>
	<20130402191130.GB31760@redhat.com>
	<CAE9FiQViU_X-idHyFmRFQXmP23oWN63XkAr3KmXsfys1VBR53g@mail.gmail.com>
	<20130402201148.GJ29506@redhat.com>
	<CAE9FiQURMNjPYYze-tPn4Ssrc4TqMqTuvwRRhoVYEnGLF4Z0cQ@mail.gmail.com>
	<20130403131842.GA5939@redhat.com>
	<CAE9FiQUO-fLY-k_gmw6cg56YEN52VRvZuXr+f1EnywKr_cGc4Q@mail.gmail.com>
Date: Wed, 3 Apr 2013 10:32:23 -0700
X-Google-Sender-Auth: b4Tyxh6r-TZgy5TBC305NTYtBOM
Message-ID: <CAE9FiQXg2+DCd0BGRyKo4KWsMXdPZz74OjpQrUP=ciok2AZhuA@mail.gmail.com>
Subject: Re: [PATCH 3/4] x86, kdump: Retore crashkernel= to allocate low
From: Yinghai Lu <yinghai@kernel.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>, WANG Chao <chaowang@redhat.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 10:12 AM, Yinghai Lu <yinghai@kernel.org> wrote:
> On Wed, Apr 3, 2013 at 6:18 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
>> - implement crashkernel_no_auto_low option to opt out of auto reserved
>>   low memory
>
> No, that is ugly.
...
>
> It's *you* want me to change "Crash kernel low" to "Crash kernel".
>
> Do we need to drop second patch? So will still keep
> "Crash kernel low" in /proc/iomem?

also we can drop the last patch and keep "crashkernel_high=" and
"crashkernel_low="

as you even like to introduce "crashkernel_no_auto_low".

Thanks

Yinghai
