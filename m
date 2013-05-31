Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab3EaPzM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 11:55:12 -0400
Received: from mail-ob0-f176.google.com ([209.85.214.176]:39211 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab3EaPzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 11:55:07 -0400
MIME-Version: 1.0
In-Reply-To: <20130531154815.GG27176@twins.programming.kicks-ass.net>
References: <1369332423-4400-1-git-send-email-ahh@google.com>
	<CABPqkBT6Hsq9ttSAP_c7R_GOEOCECu3Di_gjwvveFVrfVRTP+Q@mail.gmail.com>
	<20130531154815.GG27176@twins.programming.kicks-ass.net>
Date: Fri, 31 May 2013 17:55:05 +0200
Message-ID: <CABPqkBQ3zCMim_1vR2DAB-cOaLxMqm0CZ6uBWj6HpoJ2fZvszw@mail.gmail.com>
Subject: Re: [PATCH] perf: reduce stack usage of schedule_events
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andrew Hunter <ahh@google.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 5:48 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, May 31, 2013 at 04:21:04PM +0200, Stephane Eranian wrote:
>> Hi,
>>
>> Any comment on this patch?
>> It does really help with stack pressure and will help fix a PEBS-LL issue.
>
> Yeah, its on my todo list, but I've been spending all of my time trying
> to fix all the bugs Vince has been throwing my way.
>
I have seen some of his reports but not all of them I suspect.
Are they all on LKML?

>
