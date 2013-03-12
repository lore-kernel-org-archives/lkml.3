Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932357Ab3CLONE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 10:13:04 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:42904 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889Ab3CLOND (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 10:13:03 -0400
MIME-Version: 1.0
In-Reply-To: <20130312135803.GA21741@gmail.com>
References: <1360706658-13468-1-git-send-email-andi@firstfloor.org>
	<CABPqkBQQ6NuEdWFGjg1cU4VRWrYPFFYoegXmXfhwwFYQPUZOmQ@mail.gmail.com>
	<20130312135803.GA21741@gmail.com>
Date: Tue, 12 Mar 2013 15:13:01 +0100
Message-ID: <CABPqkBTPv81Lrj6cEUvGA9aMDvPWiC6RZpxxx_TSzGnzDE+9sw@mail.gmail.com>
Subject: Re: Basic perf PMU support for Haswell v6
From: Stephane Eranian <eranian@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>, "mingo@elte.hu" <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 12, 2013 at 2:58 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@google.com> wrote:
>
>> Hi,
>>
>> I am not seeing those patches in tip.git tree as of today.
>> What is still wrong with those patches? I think they
>> are good for providing the basic enablement for HSW.
>
> There were still problems with them so they didn't make it
> into v3.9 - now that the development window is open I'll check
> the latest iteration (v9), in a couple of days.
>
Ok, then. We need to move forward with HSW now.
Thanks.
