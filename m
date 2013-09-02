Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755283Ab3IBIYQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Sep 2013 04:24:16 -0400
Received: from mail-qa0-f52.google.com ([209.85.216.52]:55356 "EHLO
	mail-qa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753273Ab3IBIYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Sep 2013 04:24:14 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <87ob8cdji8.fsf@tassilo.jf.intel.com>
References: <alpine.DEB.2.10.1308301334410.19094@vincent-weaver-1.um.maine.edu>
	<CAMsRxfLSnNi_vESxYHM5w0tQrOtOPsEy3ythoViRMBbEi+XHGw@mail.gmail.com>
	<87ob8cdji8.fsf@tassilo.jf.intel.com>
Date: Mon, 2 Sep 2013 10:24:13 +0200
Message-ID: <CAMsRxfLf4mSVEMnDr1AqD-=qrhBoeVWK6H0Jhb5kcHK7=OajmQ@mail.gmail.com>
Subject: Re: perf_event: rdpmc self-monitoring overhead issue
From: Stephane Eranian <eranian@googlemail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>,
        LKML <linux-kernel@vger.kernel.org>, linux-perf-users@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 2, 2013 at 4:50 AM, Andi Kleen <andi@firstfloor.org> wrote:
> Stephane Eranian <eranian@googlemail.com> writes:
>
>> I don't see a flag in mmap() to fault it in immediately.
>
> MAP_PRESENT
>
I could not find this constant defined anywhere in the kernel source tree
nor in /usr/include. Are you sure of the name?
